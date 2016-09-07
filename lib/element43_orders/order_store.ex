defmodule Element43.Orders.OrderStore do
  @moduledoc """
    Stores orders in DB.
  """
  use GenServer

  import RethinkDB.Query

  require ConCache

  @doc """
    Wrap start_link.
  """
  def start_link do
    GenServer.start_link(__MODULE__, [], name: {:global, :order_store})
  end

  @doc """
    Initialize database tables and indices.
  """
  def init(_params) do
    {:ok, %{database: Config.get(:element43_orders, :rethink_database)}}
  end

  @doc """
    Store market in DB.
  """
  def handle_call({:store_market, message}, _from, state) do
    data = message |> :jiffy.decode([:return_maps])
    data = Map.put(data, :id, [data["regionID"], data["typeID"]])

    Task.async(fn () ->
      state.database
      |> db
      |> table("markets")
      |> insert(data, conflict: "replace")
      |> Element43.Orders.RethinkConnection.run(durability: "hard", timeout: 60_000)

      ConCache.delete(:region, data["regionID"])
      ConCache.delete(:type, data["typeID"])
    end)

    {:reply, :ok, state}
  end
end

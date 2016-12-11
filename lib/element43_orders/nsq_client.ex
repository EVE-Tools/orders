defmodule Element43.Orders.NSQClient do
  use GenServer

  import RethinkDB.Query
  require ConCache

  @doc """
    Wrap start_link.
  """
  def start_link do
    GenServer.start_link(__MODULE__, [], name: {:global, :nsq_publisher})
  end

  @doc """
    Initialize server and open NSQ connection.
  """
  def init(_params) do
    {:ok, consumer} = NSQ.Consumer.Supervisor.start_link("orders", "orders",
      %NSQ.Config{
        nsqds: [Config.get(:element43_orders, :nsqd)],
        max_in_flight: 100,
        deflate: true,
        deflate_level: 9,
        msg_timeout: 60_000,
        output_buffer_timeout: 1_000,
        output_buffer_size: 64_000,
        message_handler: Element43.Orders.NSQClient
      })

    {:ok, consumer}
  end

  @doc """
    Store message in database and invalidate caches.
  """
  def handle_message(body, _msg) do
    data = body |> :jiffy.decode([:return_maps])
    data = Map.put(data, :id, [data["regionID"], data["typeID"]])
    database = Config.get(:element43_orders, :rethink_database)

    database
    |> db
    |> table("markets")
    |> insert(data, conflict: "replace")
    |> Element43.Orders.RethinkConnection.run(durability: "hard")

    ConCache.delete(:region, data["regionID"])
    ConCache.delete(:type, data["typeID"])

    :ok
  end
end

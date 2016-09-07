defmodule Element43.Orders.Bootstrap do
  @moduledoc """
    Bootstraps the database.
  """

  use GenServer

  require RethinkDB.Lambda

  import RethinkDB.Query

  @doc """
    Wrap start_link.
  """
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  @doc """
    Initialize database tables and indices.
  """
  def init(_params) do
    database_name = Config.get(:element43_orders, :rethink_database)

    create_database(database_name)
    create_tables(database_name)
    create_indices(database_name)

    {:ok, nil}
  end

  defp create_database(database_name) do
    db_create(database_name) |> Element43.Orders.RethinkConnection.run
    :ok
  end

  defp create_tables(database_name) do
    do_create_table(database_name, "markets")
  end

  defp create_indices(database_name) do
    # ID is array of [regionID, typeID], so no compound index needed
    create_index_for_attribute(database_name, "markets", "regionID", "regionID")
    create_index_for_attribute(database_name, "markets", "typeID", "typeID")
  end

  defp do_create_table(database_name, name) do
    db(database_name)
    |> table_create(name, durability: "soft")
    |> Element43.Orders.RethinkConnection.run
  end

  defp create_index_for_attribute(database_name, table_name, index_name, attribute) do
    lambda = RethinkDB.Lambda.lambda(fn(row) -> row[attribute] end)

    db(database_name) |> table(table_name)
    |> index_create(index_name, lambda)
    |> Element43.Orders.RethinkConnection.run
  end
end

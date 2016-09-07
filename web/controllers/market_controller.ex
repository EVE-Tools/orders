defmodule Element43.Orders.MarketController do
  @db Application.get_env(:element43_orders, :rethink_database)

  use Element43.Orders.Web, :controller

  import RethinkDB.Query
  require ConCache

  def region(conn, %{"region_id" => region_id}) do
    {region_id, _} = Integer.parse(region_id)
    result = get_or_store_region_cache(region_id)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(200, result)
  end

  def type(conn, %{"type_id" => type_id}) do
    {type_id, _} = Integer.parse(type_id)
    result = get_or_store_type_cache(type_id)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(200, result)
  end

  def region_type(conn, %{"region_id" => region_id, "type_id" => type_id}) do
    {region_id, _} = Integer.parse(region_id)
    {type_id, _} = Integer.parse(type_id)

    result = db(@db)
    |> table("markets")
    |> get([region_id, type_id])
    |> Element43.Orders.RethinkConnection.run
    |> unwrap_orders
    |> :jiffy.encode

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(200, result)
  end

  defp get_or_store_region_cache(region_id) do
    ConCache.get_or_store(:region, region_id, fn() ->
      result = db(@db)
      |> table("markets")
      |> get_all(region_id, index: "regionID")
      |> Element43.Orders.RethinkConnection.run
      |> unwrap_orders
      |> :jiffy.encode
    end)
  end

  defp get_or_store_type_cache(type_id) do
    ConCache.get_or_store(:region, type_id, fn() ->
      result = db(@db)
      |> table("markets")
      |> get_all(type_id, index: "typeID")
      |> Element43.Orders.RethinkConnection.run
      |> unwrap_orders
      |> :jiffy.encode
    end)
  end

  defp unwrap_orders(market) do
    # Take data from DB and add region, type and time information
    market.data |> market_to_orders
  end

  defp market_to_orders(rowsets) when is_list(rowsets) do
    Enum.flat_map(rowsets, fn market ->
      merge_orders_with_market(market)
    end)
  end

  defp market_to_orders(market) do
    merge_orders_with_market(market)
  end

  defp merge_orders_with_market(market) do
    annotation = %{
      "regionID": market["regionID"],
      "typeID": market["typeID"],
      "generatedAt": market["generatedAt"]
    }

    Enum.map(market["orders"], fn order ->
      Map.merge(order, annotation)
    end)
  end
end

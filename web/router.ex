defmodule Element43.Orders.Router do
  use Element43.Orders.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/orders/v1", Element43.Orders do
    pipe_through :api

    get "/region/:region_id/", MarketController, :region
    get "/type/:type_id/", MarketController, :type
    get "/region/:region_id/type/:type_id/", MarketController, :region_type
  end
end

defmodule Element43.Orders do

  alias Element43.Orders.RethinkConnection
  alias Element43.Orders.Bootstrap
  alias Element43.Orders.OrderStore
  alias Element43.Orders.NSQClient

  use Application

  require ConCache

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    rethink_host = Config.get(:element43_orders, :rethink_host)
    rethink_port = Config.get(:element43_orders, :rethink_port)
    rethink_config = [host: rethink_host, port: rethink_port]

    # Define workers and child supervisors to be supervised
    children = [
      #
      # Caches
      #

      # Cache for full-region queries
      worker(ConCache, [[], [name: :region]], id: :region_cache),

      # Cache for type queries
      worker(ConCache, [[], [name: :type]], id: :type_cache),

      # Start the endpoint when the application starts
      supervisor(Element43.Orders.Endpoint, []),
      # Start your own worker by calling: Element43.Orders.Worker.start_link(arg1, arg2, arg3)
      # worker(Element43.Orders.Worker, [arg1, arg2, arg3]),

      worker(RethinkConnection, [rethink_config], restart: :permanent),
      worker(Bootstrap, []),
      worker(NSQClient, [], restart: :permanent),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Element43.Orders.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Element43.Orders.Endpoint.config_change(changed, removed)
    :ok
  end
end

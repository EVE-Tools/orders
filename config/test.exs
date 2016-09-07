use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :element43_orders, Element43.Orders.Endpoint,
  http: [port: 4001],
  server: false

  config :element43_orders,
    rethink_host: {:system, "RETHINK_HOST", "rethinkdb-orders"},
    rethink_port: {:system, "RETHINK_PORT", 28015},
    rethink_database: "element43_orders_dev",
    nsqd: {:system, "NSQD_SERVER_IP", "nsqd:4150"}

# Print only warnings and errors during test
config :logger, level: :warn

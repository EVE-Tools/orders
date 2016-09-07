use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :element43_orders, Element43.Orders.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :element43_orders,
  rethink_host: {:system, "RETHINK_HOST", "rethinkdb-orders"},
  rethink_port: {:system, "RETHINK_PORT", 28015},
  rethink_database: "element43_orders_dev",
  nsqd: {:system, "NSQD_SERVER_IP", "nsqd:4150"}


# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

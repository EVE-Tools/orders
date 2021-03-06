use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :element43_orders, Element43.Orders.Endpoint,
  secret_key_base: {:system, "SECRET_KEY_BASE"}

  config :element43_orders,
    rethink_host: {:system, "RETHINK_HOST", "rethinkdb-orders"},
    rethink_port: {:system, "RETHINK_PORT", 28015},
    rethink_database: "element43_orders",
    nsqd: {:system, "NSQD_SERVER_IP", "nsqd:4150"}

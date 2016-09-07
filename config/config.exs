# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :element43_orders, Element43.Orders.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zH5OwwugrSCN0du1B6MZSRS/tc9RDWIn8hYalkhYFtwSmbv3+zmXRODuIk2+9CBV",
  render_errors: [view: Element43.Orders.ErrorView, accepts: ~w(json)],
  pubsub: [name: Element43.Orders.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  level: :info,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

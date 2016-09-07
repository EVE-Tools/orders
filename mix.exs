defmodule Element43.Orders.Mixfile do
  use Mix.Project

  def project do
    [app: :element43_orders,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Element43.Orders, []},
     applications: [:phoenix, :phoenix_pubsub, :cowboy, :logger, :gettext,
                    :elixir_nsq, :con_cache, :rethinkdb, :jiffy, :cors_plug,
                    :exactor, :uuid]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:elixir_nsq, github: "wistia/elixir_nsq"},
     {:rethinkdb, "~> 0.4"},
     {:jiffy, "~> 0.14"},
     {:cors_plug, "~> 1.1"},
     {:con_cache, "~> 0.11.1"},
     {:distillery, "~> 0.9"}]
  end
end

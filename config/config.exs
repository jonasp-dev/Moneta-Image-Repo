# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :moneta,
  ecto_repos: [Moneta.Repo]

# Configures the endpoint
config :moneta, MonetaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LtuJV/AzfnmN5PByNflhQTz5e9ZHeppwHXllVJEjjlSErWyqUBq9i/q9033N4pJA",
  render_errors: [view: MonetaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Moneta.PubSub,
  live_view: [signing_salt: "wOnqhEPl"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

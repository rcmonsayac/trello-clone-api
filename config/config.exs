# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :trello_clone_api,
  ecto_repos: [TrelloCloneApi.Repo]

# Configures the endpoint
config :trello_clone_api, TrelloCloneApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "U1sG2phPP4ttrguJjsabB8FA1f43ayUa5/OAhlI9ZqpLMXjOmnoyQECknYhEgLcs",
  render_errors: [view: TrelloCloneApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TrelloCloneApi.PubSub,
  live_view: [signing_salt: "kFUPys66"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :trello_clone_api, TrelloCloneApi.Repo, migration_primary_key: [type: :uuid]

config :trello_clone_api, TrelloCloneApiWeb.Auth.Guardian,
  issuer: "trello_clone_api",
  secret_key: "LgeWEZ35Nuafc9JFmcOJnbQ395uELYmYTDXdc50eT9UDOdEk3sk1AgCtyfipWMPL"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

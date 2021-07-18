# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rad_poll,
  ecto_repos: [RadPoll.Repo]

# Configures the endpoint
config :rad_poll, RadPollWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "alAwg6MCX99yT5YV97pgf3vT37Luh+MaO7iIqSU3GcUewdqKlvhba5GpK1nwge1A",
  render_errors: [view: RadPollWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: RadPoll.PubSub,
  live_view: [signing_salt: "ECXif0vd"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

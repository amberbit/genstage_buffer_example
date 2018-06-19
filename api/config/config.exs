# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :api, Api.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/lB65V7kOtcwJuCv9Ru2DYNyrf/yAHi1Ahsu0/haL0H+gTsIT9RuhhR4DJVzRIpd",
  render_errors: [view: Api.ErrorView, accepts: ~w(json)],
  pubsub: [name: Api.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :db, Db.Repo,[
  adapter: Ecto.Adapters.Postgres,
  database: "analytics",
  hostname: "localhost"
]

config :api, :ecto_repos, [Db.Repo]

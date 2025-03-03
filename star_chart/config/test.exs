import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :star_chart, StarChart.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "star_chart_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :star_chart, StarChartWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "VVzNViMXkrmONKypDysj2olsxjdRlCCQgDnQ60HpyFpX/5LZ9iiQAIljMKzsbAye",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# ExCoveralls Configuration
config :excoveralls,
  coverage_dir: "cover",
  formatter: ExCoveralls.Formatter.HTML,
  ignore_modules: []

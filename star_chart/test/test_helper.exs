ExUnit.start()

# Enable the cube extension for the test database
StarChart.Repo.query!("CREATE EXTENSION IF NOT EXISTS cube", [])

# Set the sandbox mode
Ecto.Adapters.SQL.Sandbox.mode(StarChart.Repo, :manual)

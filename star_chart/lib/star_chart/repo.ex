defmodule StarChart.Repo do
  use Ecto.Repo,
    otp_app: :star_chart,
    adapter: Ecto.Adapters.Postgres
end

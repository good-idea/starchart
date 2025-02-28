defmodule StarChartWeb.API.V1.StarSystemController do
  use StarChartWeb, :controller

  alias StarChart.Astronomy
  alias StarChart.Astronomy.StarSystem

  action_fallback StarChartWeb.FallbackController

  def index(conn, _params) do
    star_systems = Astronomy.list_star_systems()
    render(conn, :index, star_systems: star_systems)
  end

  def show(conn, %{"id" => id}) do
    star_system = Astronomy.get_star_system!(id)
    render(conn, :show, star_system: star_system)
  end
end
defmodule StarChartWeb.API.V1.StarSystemController do
  use StarChartWeb, :controller

  alias StarChart.Astronomy
  alias StarChart.Astronomy.StarSystem

  action_fallback StarChartWeb.FallbackController

  def index(conn, _params) do
    star_systems = Astronomy.list_star_systems()
    render(conn, :index, star_systems: star_systems)
  end

  def show(conn, %{"id" => id}) do
    star_system = Astronomy.get_star_system!(id)
    render(conn, :show, star_system: star_system)
  end
end

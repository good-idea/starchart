defmodule StarChartWeb.API.V1.StarController do
  use StarChartWeb, :controller

  alias StarChart.Astronomy
  alias StarChart.Astronomy.Star

  action_fallback StarChartWeb.FallbackController

  def index(conn, %{"star_system_id" => star_system_id}) do
    stars = Astronomy.list_stars_by_system(star_system_id)
    render(conn, :index, stars: stars)
  end

  def show(conn, %{"id" => id}) do
    star = Astronomy.get_star!(id)
    render(conn, :show, star: star)
  end
end

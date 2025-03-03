defmodule StarChartWeb.API.V1.StarController do
  use StarChartWeb, :controller

  alias StarChart.Astronomy

  action_fallback StarChartWeb.FallbackController

  def index(conn, %{"star_system_id" => star_system_id}) do
    case Astronomy.get_star_system(star_system_id) do
      nil ->
        conn |> put_status(:not_found) |> render(StarChartWeb.ErrorJSON, :"404")

      star_system ->
        stars = Astronomy.list_stars_by_system(star_system.id)
        render(conn, :index, stars: stars)
    end
  end

  def show(conn, %{"id" => id}) do
    star = Astronomy.get_star!(id)
    render(conn, :show, star: star)
  end
end

defmodule StarChartWeb.API.V1.StarController do
  use StarChartWeb, :controller

  alias StarChart.Astronomy

  action_fallback StarChartWeb.FallbackController

  def show(conn, %{"id" => id}) do
    star = Astronomy.get_star!(id)
    render(conn, :show, star: star)
  end
end

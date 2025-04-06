defmodule StarChartWeb.API.V1.StarController do
  use StarChartWeb, :controller

  use OpenApiSpex.ControllerSpecs

  tags ["Stars"]

  alias StarChart.Astronomy

  action_fallback StarChartWeb.FallbackController

  operation :show,
    summary: "Retrieve a star",
    description: "Returns details for a star given its ID.",
    parameters: [
      id: [in: :path, description: "Star ID", type: :integer, example: 1]
    ],
    responses: [
      ok: {"Star", "application/json", StarChartWeb.Schema.GetStarResponse}
      # TODO: Add NotFound schema
      # not_found: {"Not Found", "application/json", %{}}
    ]

  def show(conn, %{"id" => id}) do
    star = Astronomy.get_star!(id)
    render(conn, :show, star: star)
  end
end

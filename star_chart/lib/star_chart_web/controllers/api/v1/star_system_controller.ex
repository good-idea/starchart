defmodule StarChartWeb.API.V1.StarSystemController do
  use StarChartWeb, :controller

  alias StarChart.Astronomy
  alias StarChartWeb.Utils.Params

  action_fallback StarChartWeb.FallbackController

  def index(conn, params) do
    pagination_schema = %{
      "page" => %{type: :integer, min: 1, default: 1},
      "page_size" => %{type: :integer, min: 1, max: 200, default: 100},
      "spectral_class" => %{type: :string, max_length: 1, pattern: ~r/^[OBAFGKMLTY]$|^U$/}
    }
    
    case Params.validate_params(params, pagination_schema) do
      {:ok, validated_params} ->
        page = validated_params["page"]
        page_size = validated_params["page_size"]
        spectral_class = validated_params["spectral_class"]
        
        paginated_star_systems = Astronomy.list_star_systems_paginated(
          page: page, 
          page_size: page_size,
          spectral_class: spectral_class
        )
        
        render(conn, :index, star_systems: paginated_star_systems)
        
      {:error, {param, message}} ->
        conn
        |> put_status(:bad_request)
        |> put_view(StarChartWeb.ErrorJSON)
        |> render(:"400", %{detail: "Invalid parameter '#{param}': #{message}"})
    end
  end

  def show(conn, %{"id" => id}) do
    star_system = Astronomy.get_star_system!(id)
    render(conn, :show, star_system: star_system)
  end
end

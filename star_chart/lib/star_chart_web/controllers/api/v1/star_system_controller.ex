defmodule StarChartWeb.API.V1.StarSystemController do
  use StarChartWeb, :controller

  alias StarChart.Astronomy
  alias StarChart.Astronomy.Nearby
  alias StarChartWeb.Utils.Params

  action_fallback StarChartWeb.FallbackController

  def index(conn, params) do
    pagination_schema = %{
      "page" => %{type: :integer, min: 1, default: 1},
      "page_size" => %{type: :integer, min: 1, max: 200, default: 100},
      "spectral_class" => %{type: :string, max_length: 1, pattern: ~r/^[OBAFGKMLTY]$|^U$/},
      "min_stars" => %{type: :integer, min: 1},
      "max_stars" => %{type: :integer, min: 1}
    }
    
    case Params.validate_params(params, pagination_schema) do
      {:ok, validated_params} ->
        page = validated_params["page"]
        page_size = validated_params["page_size"]
        spectral_class = validated_params["spectral_class"]
        min_stars = validated_params["min_stars"]
        max_stars = validated_params["max_stars"]
        
        paginated_star_systems = Astronomy.list_star_systems_paginated(
          page: page, 
          page_size: page_size,
          spectral_class: spectral_class,
          min_stars: min_stars,
          max_stars: max_stars
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

  @doc """
  Lists star systems that are nearby to the specified origin star system.

  ## Parameters
    - conn: The connection
    - params: The request parameters
      * "origin_id": The ID of the origin star system
      * "max_distance": Maximum distance in light years (optional, default: 25.0)

  ## Returns
    - JSON response with nearby star systems and their distances
  """
  def nearby(conn, %{"origin_id" => origin_id} = params) do
    # Parse the origin_id to integer
    with {id, _} <- Integer.parse(origin_id) do
      # Extract max_distance from params if provided
      max_distance = case params do
        %{"max_distance" => distance_str} ->
          case Float.parse(distance_str) do
            {distance, _} -> distance
            :error -> 25.0  # Default if parsing fails
          end
        _ -> 25.0  # Default if not provided
      end

      # Call the Nearby module to find nearby star systems
      case Nearby.find_nearby_star_systems(id, max_distance: max_distance) do
        {:error, :not_found} ->
          conn
          |> put_status(:not_found)
          |> put_view(StarChartWeb.ErrorJSON)
          |> render(:"404")

        nearby_systems ->
          render(conn, :nearby, nearby_systems: nearby_systems)
      end
    else
      _ ->
        conn
        |> put_status(:bad_request)
        |> put_view(StarChartWeb.ErrorJSON)
        |> render(:"400", %{detail: "Invalid star system ID"})
    end
  end
end

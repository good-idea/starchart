defmodule StarChartWeb.API.V1.StarSystemController do
  use StarChartWeb, :controller
  use OpenApiSpex.ControllerSpecs
  tags(["Stars"])

  alias StarChart.Astronomy
  alias StarChart.Astronomy.Nearby
  alias StarChartWeb.Utils.Params

  action_fallback(StarChartWeb.FallbackController)

  operation(:index,
    summary: "List star systems",
    description: "Returns a paginated list of star systems with optional filtering.",
    parameters: [
      page: [in: :query, description: "Page number", type: :integer, example: 1],
      page_size: [
        in: :query,
        description: "Number of items per page",
        type: :integer,
        example: 100
      ],
      spectral_class: [
        in: :query,
        description:
          "Filter by spectral class. Allowed values are O, B, A, F, G, K, M, L, T, Y, or U for Unknown.",
        example: "G",
        schema: StarChartWeb.Schema.Parameters.spectral_class()
      ],
      min_stars: [in: :query, description: "Minimum number of stars", type: :integer, example: 1],
      max_stars: [in: :query, description: "Maximum number of stars", type: :integer, example: 10]
    ],
    responses: [
      ok:
        {"ListStarSystemsResponse", "application/json",
         StarChartWeb.Schema.ListStarSystemsResponse}
    ]
  )

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

        paginated_star_systems =
          Astronomy.list_star_systems_paginated(
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

  operation(:show,
    summary: "Retrieve a star system",
    description: "Returns detailed information for a star system given its ID.",
    parameters: [
      id: [in: :path, description: "Star system ID", type: :integer, example: 1]
    ],
    responses: [
      ok: {"Star System", "application/json", StarChartWeb.Schema.GetStarSystemResponse}
      # TODO set up not found schema
      # not_found: {"Not Found", "application/json", %{}}
    ]
  )

  def show(conn, %{"id" => id}) do
    star_system = Astronomy.get_star_system!(id)
    render(conn, :show, star_system: star_system)
  end

  operation(:nearby,
    summary: "Retrieve nearby star systems",
    description:
      "Returns the list of star systems that are near the specified origin star system. The results can be filtered by maximum distance (in light years), spectral class, and star counts.",
    parameters: [
      origin_id: [in: :path, description: "Origin star system ID", type: :integer, example: 1],
      distance: [
        in: :query,
        description: "Maximum distance in light years (default: 25.0, min: 0.1, max: 100)",
        schema: %OpenApiSpex.Schema{
          type: :number,
          format: :float,
          minimum: 0.1,
          maximum: 100.0
        },
        # type: :float,
        # format: :float,
        example: 25.0
        # minimum: 0.1,
        # maximum: 100.0
      ],
      page: [in: :query, description: "Page number", type: :integer, example: 1],
      page_size: [
        in: :query,
        description: "Number of items per page",
        type: :integer,
        example: 100
      ],
      spectral_class: [
        in: :query,
        description:
          "Filter by spectral class. Allowed values are O, B, A, F, G, K, M, L, T, Y, or U for Unknown.",
        example: "G",
        schema: StarChartWeb.Schema.Parameters.spectral_class()
      ],
      min_stars: [in: :query, description: "Minimum number of stars", type: :integer, example: 1],
      max_stars: [in: :query, description: "Maximum number of stars", type: :integer, example: 10]
    ],
    responses: [
      ok:
        {"NearbyStarSystemsResponse", "application/json",
         StarChartWeb.Schema.NearbyStarSystemsResponse}
    ]
  )

  def nearby(conn, %{"origin_id" => origin_id} = params) do
    # Define validation schema for the parameters
    params_schema = %{
      "distance" => %{type: :float, min: 0.1, max: 100.0, default: 25.0},
      "page" => %{type: :integer, min: 1, default: 1},
      "page_size" => %{type: :integer, min: 1, max: 200, default: 100},
      "spectral_class" => %{type: :string, max_length: 1, pattern: ~r/^[OBAFGKMLTY]$|^U$/},
      "min_stars" => %{type: :integer, min: 1},
      "max_stars" => %{type: :integer, min: 1}
    }

    # Parse the origin_id to integer
    with {id, _} <- Integer.parse(origin_id),
         {:ok, validated_params} <- Params.validate_params(params, params_schema) do
      # Extract the validated parameters
      distance = validated_params["distance"]
      page = validated_params["page"]
      page_size = validated_params["page_size"]
      spectral_class = validated_params["spectral_class"]
      min_stars = validated_params["min_stars"]
      max_stars = validated_params["max_stars"]

      # Call the Nearby module to find nearby star systems with filters and pagination
      case Nearby.find_nearby_star_systems(id,
             max_distance: distance,
             page: page,
             page_size: page_size,
             spectral_class: spectral_class,
             min_stars: min_stars,
             max_stars: max_stars
           ) do
        {:error, :not_found} ->
          conn
          |> put_status(:not_found)
          |> put_view(StarChartWeb.ErrorJSON)
          |> render(:"404")

        paginated_systems ->
          render(conn, :nearby, paginated_systems)
      end
    else
      {:error, {param, message}} ->
        conn
        |> put_status(:bad_request)
        |> put_view(StarChartWeb.ErrorJSON)
        |> render(:"400", %{detail: "Invalid parameter '#{param}': #{message}"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> put_view(StarChartWeb.ErrorJSON)
        |> render(:"400", %{detail: "Invalid star system ID"})
    end
  end
end

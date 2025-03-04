defmodule StarChart.Astronomy.Nearby do
  @moduledoc """
  Functions for finding nearby star systems based on spatial distance.
  """

  import Ecto.Query, warn: false
  alias StarChart.Repo
  alias StarChart.Astronomy.{StarSystem, Star}
  alias StarChart.Astronomy.Utils

  @doc """
  Finds star systems within a specified distance from an origin star system.

  ## Parameters
    - origin_id: The ID of the origin star system
    - opts: Options for filtering and pagination
      * :max_distance - Maximum distance in light years (default: 25.0)
      * :page - The page number (default: 1)
      * :page_size - The number of items per page (default: 100)
      * :spectral_class - Filter by spectral class (optional)
      * :min_stars - Filter for star systems with at least this many stars (optional)
      * :max_stars - Filter for star systems with at most this many stars (optional)

  ## Returns
    - A map containing:
      * :entries - List of maps with system and distance information
      * :page_number - Current page number
      * :page_size - Number of items per page
      * :total_entries - Total number of star systems matching the criteria
      * :total_pages - Total number of pages
    - Returns {:error, :not_found} if the origin system doesn't exist

  ## Examples

      iex> find_star_systems(1, max_distance: 10.0, page: 2, page_size: 20, spectral_class: "G")
      %{
        entries: [%{system: %StarSystem{...}, distance: %Distance{...}}, ...],
        page_number: 2,
        page_size: 20,
        total_entries: 45,
        total_pages: 3
      }
  """
  def find_nearby_star_systems(origin_id, opts \\ []) do
    # Get options with defaults
    max_distance = Keyword.get(opts, :max_distance, 25.0)
    page = Keyword.get(opts, :page, 1)
    page_size = Keyword.get(opts, :page_size, 100)
    spectral_class = Keyword.get(opts, :spectral_class)
    min_stars = Keyword.get(opts, :min_stars)
    max_stars = Keyword.get(opts, :max_stars)
    
    # Convert distance to parsecs (the x,y,z coordinates use parsecs)
    distance_parsecs = Utils.light_years_to_parsec(max_distance)

    origin_system = StarChart.Astronomy.get_star_system(origin_id)

    if origin_system == nil do
      {:error, :not_found}
    else
      %{primary_star: %{x: origin_x, y: origin_y, z: origin_z}} = origin_system

      # Build the query using the composable pattern
      query_params = %{
        origin_id: origin_id,
        origin_x: origin_x,
        origin_y: origin_y,
        origin_z: origin_z,
        distance_parsecs: distance_parsecs,
        spectral_class: spectral_class,
        min_stars: min_stars,
        max_stars: max_stars
      }

      # Build and execute the query
      nearby_systems =
        build_query(query_params)
        |> Repo.all()
        |> Enum.map(&StarChart.Astronomy.preload_primary_star/1)
        |> Enum.map(fn system ->
          distance = Utils.calculate_distance_between_systems(origin_system, system)
          %{
            system: system,
            distance: distance
          }
        end)
        |> Enum.filter(fn %{distance: distance} ->
          distance.distance_parsecs <= distance_parsecs
        end)
        |> Enum.sort_by(fn %{distance: distance} -> distance.distance_parsecs end)
      
      # Calculate total entries and pages
      total_entries = length(nearby_systems)
      total_pages = ceil(total_entries / page_size)
      
      # Apply pagination
      entries = 
        nearby_systems
        |> Enum.slice(((page - 1) * page_size), page_size)
      
      # Return paginated result
      %{
        entries: entries,
        page_number: page,
        page_size: page_size,
        total_entries: total_entries,
        total_pages: total_pages
      }
    end
  end

  # Base query for nearby star systems
  defp base_query(params) do
    from s in StarSystem,
      join: star in Star,
      on: star.star_system_id == s.id and star.is_primary == true,
      where: s.id != ^params.origin_id,
      where:
        fragment(
          "cube(array[?::float8,?::float8,?::float8]) <-> cube(array[?::float8,?::float8,?::float8]) <= ?",
          ^params.origin_x,
          ^params.origin_y,
          ^params.origin_z,
          star.x,
          star.y,
          star.z,
          ^params.distance_parsecs
        )
  end

  # Filter by spectral class
  defp filter_by_spectral_class(query, %{spectral_class: nil}), do: query
  defp filter_by_spectral_class(query, %{spectral_class: ""}), do: query
  defp filter_by_spectral_class(query, %{spectral_class: spectral_class}) do
    from [s, star] in query,
      where: star.spectral_class == ^spectral_class
  end

  # Apply star count filters
  defp filter_by_star_count(query, %{min_stars: nil, max_stars: nil}), do: query
  defp filter_by_star_count(query, params) do
    # Create the star count subquery
    star_count_query = from star in Star,
      group_by: star.star_system_id,
      select: %{star_system_id: star.star_system_id, count: count(star.id)}

    # Join with the star count subquery
    query = from s in query,
      join: sc in subquery(star_count_query),
      on: s.id == sc.star_system_id

    # Apply filters
    query
    |> filter_by_min_stars(params)
    |> filter_by_max_stars(params)
  end

  # Filter by minimum number of stars
  defp filter_by_min_stars(query, %{min_stars: nil}), do: query
  defp filter_by_min_stars(query, %{min_stars: min_stars}) do
    from [s, star, sc] in query,
      where: sc.count >= ^min_stars
  end

  # Filter by maximum number of stars
  defp filter_by_max_stars(query, %{max_stars: nil}), do: query
  defp filter_by_max_stars(query, %{max_stars: max_stars}) do
    from [s, star, sc] in query,
      where: sc.count <= ^max_stars
  end

  # Build the complete query by composing all filters
  defp build_query(params) do
    base_query(params)
    |> filter_by_star_count(params)
    |> filter_by_spectral_class(params)
  end
end

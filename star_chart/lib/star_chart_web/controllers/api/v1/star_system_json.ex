defmodule StarChartWeb.API.V1.StarSystemJSON do
  alias StarChartWeb.API.V1.StarJSON

  @doc """
  Renders a list of star systems with pagination metadata.
  """
  def index(%{
        star_systems: %{
          entries: entries,
          page_number: page,
          page_size: page_size,
          total_entries: total_entries,
          total_pages: total_pages
        }
      }) do
    %{
      data: for(star_system <- entries, do: data(star_system)),
      meta: %{
        page: page,
        page_size: page_size,
        total_entries: total_entries,
        total_pages: total_pages
      }
    }
  end

  @doc """
  Renders a single star system.
  """
  def show(%{star_system: star_system}) do
    %{data: data(star_system)}
  end

  @doc """
  Renders a list of nearby star systems with distance information.
  """
  def nearby(%{nearby_systems: nearby_systems}) do
    Enum.map(nearby_systems, fn %{system: system, distance: distance} ->
      %{
        system: data(system),
        distance: %{
          parsecs: distance.distance_parsecs,
          light_years: distance.distance_light_years
        }
      }
    end)
  end

  defp data(%{} = star_system) do
    base = %{
      id: star_system.id,
      name: star_system.name
    }

    # Add star count if it's available
    base =
      if Map.has_key?(star_system, :star_count) do
        Map.put(base, :star_count, star_system.star_count)
      else
        base
      end

    # Add primary star if it's available
    base =
      if Map.has_key?(star_system, :primary_star) && star_system.primary_star do
        Map.put(base, :primary_star, StarJSON.data(star_system.primary_star))
      else
        base
      end

    # Add secondary stars if they're available
    if Map.has_key?(star_system, :secondary_stars) && star_system.secondary_stars do
      Map.put(
        base,
        :secondary_stars,
        for(star <- star_system.secondary_stars, do: StarJSON.data(star))
      )
    else
      base
    end
  end
end

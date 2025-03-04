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
    - distance: Maximum distance in light years (default: 25.0)

  ## Returns
    - A list of maps, each containing:
      * system: The star system
      * distance: A Distance struct with distance_parsecs and distance_light_years
    - Returns {:error, :not_found} if the origin system doesn't exist

  ## Examples

      iex> find_star_systems(1, 10.0)
      [
        %{
          system: %StarSystem{...},
          distance: %StarChart.Astronomy.Utils.Distance{
            distance_parsecs: 1.3,
            distance_light_years: 4.24
          }
        },
        ...
      ]
  """

  def find_nearby_star_systems(origin_id, opts \\ []) do
    max_distance = Keyword.get(opts, :max_distance, 25.0)
    # Convert distance to parsecs (the x,y,z coordinates use parsecs)
    distance_parsecs = Utils.light_years_to_parsec(max_distance)

    origin_system = StarChart.Astronomy.get_star_system(origin_id)

    if origin_system == nil do
      {:error, :not_found}
    else
      %{primary_star: %{x: origin_x, y: origin_y, z: origin_z}} = origin_system

      query =
        from(s in StarSystem,
          join: star in Star,
          on: star.star_system_id == s.id and star.is_primary == true,
          where: s.id != ^origin_id,
          where:
            fragment(
              "cube(array[?::float8,?::float8,?::float8]) <-> cube(array[?::float8,?::float8,?::float8]) <= ?",
              ^origin_x,
              ^origin_y,
              ^origin_z,
              star.x,
              star.y,
              star.z,
              ^distance_parsecs
            )
        )

      nearby_systems =
        Repo.all(query)
        |> Enum.map(&StarChart.Astronomy.preload_primary_star/1)

      nearby_systems
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
    end
  end
end

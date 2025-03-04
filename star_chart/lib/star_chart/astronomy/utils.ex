defmodule StarChart.Astronomy.Utils do
  @moduledoc """
  Provides utility functions for astronomical calculations and conversions.
  """

  defmodule Distance do
    @moduledoc """
    Struct representing distance between star systems in multiple units.
    """
    defstruct [:distance_parsecs, :distance_light_years]
  end

  @parsec_to_ly StarChart.Astronomy.Constants.parsec_to_ly()

  @doc """
  Converts distance from parsecs to light years.

  ## Parameters

    - `parsecs`: Distance in parsecs (float or integer).

  ## Returns

    - Distance in light years (float).

  ## Examples

      iex> StarChart.Astronomy.Utils.parsec_to_light_years(1)
      3.2615637774564364568732523

  """
  @spec parsec_to_light_years(number()) :: float()
  def parsec_to_light_years(parsecs) when is_number(parsecs) do
    parsecs * @parsec_to_ly
  end

  @doc """
  Converts distance from light years to parsecs.

  ## Parameters

    - `light_years`: Distance in light years (float or integer).

  ## Returns

    - Distance in parsecs (float).

  ## Examples

      iex> StarChart.Astronomy.Utils.light_years_to_parsec(3.26)
      1.0

  """
  @spec light_years_to_parsec(number()) :: float()
  def light_years_to_parsec(light_years) when is_number(light_years) do
    light_years / @parsec_to_ly
  end

  @doc """
  Converts Right Ascension from hours to degrees.

  ## Parameters

    - `hours`: Right Ascension in hours (float or integer).

  ## Returns

    - Right Ascension in degrees (float).

  ## Examples

      iex> StarChart.Astronomy.Utils.hours_to_degrees(1)
      15.0

  """
  @spec hours_to_degrees(number()) :: float()
  def hours_to_degrees(hours) when is_number(hours) do
    hours * 15.0
  end

  @doc """
  Converts Right Ascension from degrees to hours.

  ## Parameters

    - `degrees`: Right Ascension in degrees (float or integer).

  ## Returns

    - Right Ascension in hours (float).

  ## Examples

      iex> StarChart.Astronomy.Utils.degrees_to_hours(15.0)
      1.0

  """
  @spec degrees_to_hours(number()) :: float()
  def degrees_to_hours(degrees) when is_number(degrees) do
    degrees / 15.0
  end

  @doc """
  Calculates the distance between two star systems.

  ## Parameters
    - system1: The first star system with x, y, z coordinates in its primary_star
    - system2: The second star system with x, y, z coordinates in its primary_star

  ## Returns
    - A struct containing:
      - distance_parsecs: The distance in parsecs as a float
      - distance_light_years: The distance in light years as a float

  ## Examples
      iex> system1 = %{primary_star: %{x: 0.0, y: 0.0, z: 0.0}}
      iex> system2 = %{primary_star: %{x: 3.0, y: 4.0, z: 0.0}}
      iex> result = StarChart.Astronomy.Utils.calculate_distance_between_systems(system1, system2)
      iex> result.distance_parsecs
      5.0
      iex> result.distance_light_years
      16.307818887282182
  """
  def calculate_distance_between_systems(system1, system2) do
    # Extract coordinates from primary stars
    %{primary_star: %{x: x1, y: y1, z: z1}} = system1
    %{primary_star: %{x: x2, y: y2, z: z2}} = system2
    
    # Calculate Euclidean distance
    dx = x2 - x1
    dy = y2 - y1
    dz = z2 - z1
    
    distance_parsecs = :math.sqrt(dx * dx + dy * dy + dz * dz)
    distance_light_years = parsec_to_light_years(distance_parsecs)
    
    %Distance{
      distance_parsecs: distance_parsecs,
      distance_light_years: distance_light_years
    }
  end
end

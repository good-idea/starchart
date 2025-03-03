defmodule StarChart.Astronomy.Utils do
  @moduledoc """
  Provides utility functions for astronomical calculations and conversions.
  """

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
end

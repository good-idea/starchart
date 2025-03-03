defmodule StarChart.Astronomy.Utils do
  @moduledoc """
  Provides utility functions for astronomical calculations and conversions.
  """

  @doc """
  Converts distance from parsecs to light years.

  ## Parameters

    - `parsecs`: Distance in parsecs (float or integer).

  ## Returns

    - Distance in light years (float).

  ## Examples

      iex> StarChart.Astronomy.Utils.parsec_to_light_years(1)
      3.26

  """
  @spec parsec_to_light_years(number()) :: float()
  def parsec_to_light_years(parsecs) when is_number(parsecs) do
    parsecs * 3.26
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
    light_years * 0.3066
  end
end

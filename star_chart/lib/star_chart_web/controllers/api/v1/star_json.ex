defmodule StarChartWeb.API.V1.StarJSON do
  @doc """
  Renders a list of stars.
  """
  def index(%{stars: stars}) do
    %{data: for(star <- stars, do: data(star))}
  end

  @doc """
  Renders a single star.
  """
  def show(%{star: star}) do
    %{data: data(star)}
  end

  def data(%{} = star) do
    %{
      id: star.id,
      name: star.name,
      proper_name: star.proper_name,
      is_primary: star.is_primary,
      hip: star.hip,
      hd: star.hd,
      hr: star.hr,
      gl: star.gl,
      bayer_flamsteed: star.bayer_flamsteed,
      right_ascension: star.right_ascension,
      right_ascension_degrees: star.right_ascension_degrees,
      declination: star.declination,
      distance_parsecs: star.distance_parsecs,
      proper_motion_ra: star.proper_motion_ra,
      proper_motion_dec: star.proper_motion_dec,
      radial_velocity: star.radial_velocity,
      apparent_magnitude: star.apparent_magnitude,
      absolute_magnitude: star.absolute_magnitude,
      spectral_type: star.spectral_type,
      spectral_class: star.spectral_class,
      color_index: star.color_index,
      x: star.x,
      y: star.y,
      z: star.z,
      luminosity: star.luminosity,
      variable_type: star.variable_type,
      variable_min: star.variable_min,
      variable_max: star.variable_max,
      constellation: star.constellation,
      star_system_id: star.star_system_id
    }
  end
end

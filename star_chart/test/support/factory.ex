defmodule StarChart.Factory do
  use ExMachina.Ecto, repo: StarChart.Repo

  alias StarChart.Astronomy.{StarSystem, Star}

  def star_system_factory do
    %StarSystem{
      name: sequence(:name, &"Star System #{&1}")
    }
  end

  def star_factory do
    %Star{
      name: sequence(:name, &"Star #{&1}"),
      right_ascension: 0.0,
      right_ascension_degrees: 0.0,
      declination: 0.0,
      distance_parsecs: 0.0,
      proper_motion_ra: 0.0,
      proper_motion_dec: 0.0,
      radial_velocity: 0.0,
      apparent_magnitude: 0.0,
      absolute_magnitude: 0.0,
      spectral_type: "G2V",
      color_index: 0.0,
      x: 0.0,
      y: 0.0,
      z: 0.0,
      luminosity: 1.0,
      constellation: "Test Constellation",
      star_system: build(:star_system)
    }
  end
end

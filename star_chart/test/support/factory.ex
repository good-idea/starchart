defmodule StarChart.Factory do
  use ExMachina.Ecto, repo: StarChart.Repo

  alias StarChart.Astronomy.{StarSystem, Star}

  def star_system_factory do
    %StarSystem{
      name: sequence(:name, &"Star System #{&1}")
    }
  end

  @spectral_types [
    "G2V",
    "B9p",
    "F2III-IV",
    "B2IV",
    "M1V",
    "K0",
    "K5V",
    "K0III",
    "G0V SB",
    "DG",
    "G8III-IV",
    "G3IV",
    "M0IIIvar",
    "A7IV",
    "F7V",
    "A1p Si",
    "M5e-M9e",
    "F7:Ib-IIv SB",
    "K3Ib comp SB",
    "F8V",
    "A5m",
    "G8V",
    "K3/K4IV",
    "F5Ib",
    "K2V"
  ]

  def star_factory do
    # Default to a random spectral type
    spectral_type = Enum.random(@spectral_types)
    
    # Extract the spectral class from the first character of the spectral type
    # and ensure it's uppercase
    spectral_class = String.slice(spectral_type, 0, 1) |> String.upcase()
    
    # Check if it's a valid spectral class, otherwise use "U"
    spectral_class = 
      if spectral_class =~ ~r/[OBAFGKMLTY]/ do
        spectral_class
      else
        "U"
      end
    
    %Star{
      name: sequence(:name, &"Star #{&1}"),
      right_ascension: 0.0,
      declination: 0.0,
      distance_parsecs: 0.0,
      proper_motion_ra: 0.0,
      proper_motion_dec: 0.0,
      radial_velocity: 0.0,
      apparent_magnitude: 0.0,
      absolute_magnitude: 0.0,
      spectral_type: spectral_type,
      spectral_class: spectral_class,
      color_index: 0.0,
      x: 0.0,
      y: 0.0,
      z: 0.0,
      luminosity: 1.0,
      constellation: "Test Constellation"
    }
  end
end

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StarChart.Repo.insert!(%StarChart.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StarChart.Repo.insert!(%StarChart.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias StarChart.Repo
alias StarChart.Astronomy.StarSystem

# Clear existing data
Repo.delete_all(StarSystem)

# Add some sample star systems
[
  %{
    name: "Sol",
    distance_light_years: 0.0000158,
    spectral_type: "G2V",
    description: "Our home star system, containing Earth and 7 other planets."
  },
  %{
    name: "Alpha Centauri",
    distance_light_years: 4.37,
    spectral_type: "G2V + K1V + M5.5V",
    description: "Closest star system to Sol. A triple star system."
  },
  %{
    name: "Sirius",
    distance_light_years: 8.6,
    spectral_type: "A1V + DA",
    description: "Brightest star in Earth's night sky. A binary system with a white dwarf companion."
  }
]
|> Enum.each(fn star_system_data ->
  Repo.insert!(%StarSystem{
    name: star_system_data.name,
    distance_light_years: star_system_data.distance_light_years,
    spectral_type: star_system_data.spectral_type,
    description: star_system_data.description
  })
end)
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StarChart.Repo.insert!(%StarChart.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias StarChart.Repo
alias StarChart.Astronomy.StarSystem

# Clear existing data
Repo.delete_all(StarSystem)

# Add some sample star systems
[
  %{
    name: "Sol",
    distance_light_years: 0.0000158,
    spectral_type: "G2V",
    description: "Our home star system, containing Earth and 7 other planets."
  },
  %{
    name: "Alpha Centauri",
    distance_light_years: 4.37,
    spectral_type: "G2V + K1V + M5.5V",
    description: "Closest star system to Sol. A triple star system."
  },
  %{
    name: "Sirius",
    distance_light_years: 8.6,
    spectral_type: "A1V + DA",
    description: "Brightest star in Earth's night sky. A binary system with a white dwarf companion."
  }
]
|> Enum.each(fn star_system_data ->
  Repo.insert!(%StarSystem{
    name: star_system_data.name,
    distance_light_years: star_system_data.distance_light_years,
    spectral_type: star_system_data.spectral_type,
    description: star_system_data.description
  })
end)

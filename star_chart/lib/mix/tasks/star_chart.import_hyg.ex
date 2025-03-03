defmodule Mix.Tasks.StarChart.ImportHyg do
  @moduledoc """
  Imports star data from the HYG database CSV file.

  ## Usage

      mix star_chart.import_hyg path/to/hyg_v41.csv

  """
  use Mix.Task
  alias StarChart.Repo
  import Ecto.Query, only: []
  require Logger

  @shortdoc "Imports star data from the HYG database"
  def run([file_path]) do
    unless File.exists?(file_path) do
      Mix.raise("File not found: #{file_path}")
    end

    # Start the application to access the repo
    Mix.Task.run("app.start")

    # Parse the CSV file
    csv_data = parse_csv(file_path)

    # Process the data
    {primary_stars, companion_stars} = categorize_stars(csv_data)

    # Import the data
    import_stars(primary_stars, companion_stars)

    Mix.shell().info("Import completed successfully!")
  end

  def run(_) do
    Mix.raise("Expected a single argument with the path to the HYG CSV file")
  end

  defp parse_csv(file_path) do
    file_path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.to_list()
  end

  defp categorize_stars(csv_data) do
    Enum.reduce(csv_data, {[], []}, fn star_data, {primaries, companions} ->
      # Convert string ID to integer
      id = String.to_integer(star_data["id"])
      comp_primary = String.to_integer(star_data["comp_primary"] || "0")

      # Determine if this is a primary or companion star
      is_primary = comp_primary == 0 || comp_primary == id

      # Determine the star name using the priority order
      name = determine_star_name(star_data)

      # Create a processed star record
      processed_star =
        Map.merge(star_data, %{
          "id" => id,
          "comp_primary" => comp_primary,
          "is_primary" => is_primary,
          "name" => name
        })

      # Add to appropriate list
      if is_primary do
        {[processed_star | primaries], companions}
      else
        {primaries, [processed_star | companions]}
      end
    end)
  end

  defp determine_star_name(star_data) do
    # If proper name exists, use it directly
    if star_data["proper"] && star_data["proper"] != "" do
      star_data["proper"]
    else
      # Otherwise, use the first non-empty value from the priority list with a prefix
      ["hip", "hd", "hr", "gl", "bf"]
      |> Enum.find_value(fn field ->
        value = star_data[field]
        if value && value != "", do: {field, value}, else: nil
      end)
      |> case do
        nil -> "Unnamed Star #{star_data["id"]}"
        {field, value} -> "#{String.upcase(field)}-#{value}"
      end
    end
  end

  defp import_stars(primary_stars, companion_stars) do
    # Use a transaction to ensure all-or-nothing import
    Repo.transaction(fn ->
      Enum.each(primary_stars, fn primary ->
        # Find all companions for this primary star
        primary_id = primary["id"]

        related_companions =
          Enum.filter(companion_stars, fn companion ->
            companion["comp_primary"] == primary_id
          end)

        # Create the star system
        {:ok, star_system} = create_star_system(primary)

        # Create the primary star
        {:ok, _primary_star} = create_star(primary, star_system.id, true)

        # Create all companion stars
        Enum.each(related_companions, fn companion ->
          {:ok, _companion_star} = create_star(companion, star_system.id, false)
        end)
      end)
    end)
  end

  defp create_star_system(primary_star) do
    # Create the star system
    StarChart.Astronomy.create_star_system(%{
      name: primary_star["name"]
    })
  end

  defp create_star(star_data, star_system_id, is_primary) do
    StarChart.Astronomy.create_star(%{
      star_system_id: star_system_id,
      name: star_data["name"],
      proper_name: star_data["proper"],
      is_primary: is_primary,
      hip: parse_integer(star_data["hip"]),
      hd: parse_integer(star_data["hd"]),
      hr: parse_integer(star_data["hr"]),
      gl: star_data["gl"],
      bayer_flamsteed: star_data["bf"],
      right_ascension: parse_float(star_data["ra"]) || 0.0,
      right_ascension_degrees: (parse_float(star_data["ra"]) || 0.0) * 15.0,
      declination: parse_float(star_data["dec"]) || 0.0,
      distance_parsecs: parse_float(star_data["dist"]) || 0.0,
      proper_motion_ra: parse_float(star_data["pmra"]) || 0.0,
      proper_motion_dec: parse_float(star_data["pmdec"]) || 0.0,
      radial_velocity: parse_float(star_data["rv"]) || 0.0,
      apparent_magnitude: parse_float(star_data["mag"]) || 0.0,
      absolute_magnitude: parse_float(star_data["absmag"]) || 0.0,
      spectral_type: star_data["spect"],
      color_index: parse_float(star_data["ci"]),
      x: parse_float(star_data["x"]) || 0.0,
      y: parse_float(star_data["y"]) || 0.0,
      z: parse_float(star_data["z"]) || 0.0,
      luminosity: parse_float(star_data["lum"]) || 0.0,
      variable_type: star_data["var"],
      variable_min: parse_float(star_data["var_min"]),
      variable_max: parse_float(star_data["var_max"]),
      constellation: star_data["con"]
    })
  end

  # Helper functions to safely parse numeric values
  defp parse_integer(value) when is_nil(value) or value == "", do: nil

  defp parse_integer(value) do
    case Integer.parse(value) do
      {int, _} -> int
      :error -> nil
    end
  end

  defp parse_float(value) when is_nil(value) or value == "", do: nil

  defp parse_float(value) do
    case Float.parse(value) do
      {float, _} -> float
      :error -> nil
    end
  end
end

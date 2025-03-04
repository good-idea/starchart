defmodule StarChart.Astronomy.Star do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stars" do
    # Name of the star. Determined by the import script using the 'proper' name if available;
    # otherwise, it uses catalog identifiers in a specific priority order.
    field :name, :string

    # Proper name of the star, if it has one (e.g., "Sirius"). Source: HYG 'proper' column.
    field :proper_name, :string

    # Indicates if the star is the primary star in its star system. Source: HYG 'is_primary' column.
    field :is_primary, :boolean, default: false

    # Hipparcos catalog number. Source: HYG 'hip' column.
    field :hip, :integer

    # Henry Draper catalog number. Source: HYG 'hd' column.
    field :hd, :integer

    # Harvard Revised catalog number. Source: HYG 'hr' column.
    field :hr, :integer

    # Gliese catalog number. Source: HYG 'gl' column.
    field :gl, :string

    # Bayer or Flamsteed designation. Source: HYG 'bf' column.
    field :bayer_flamsteed, :string

    # Right Ascension in hours. Source: HYG 'ra' column.
    # Unit: Hours
    # Description: The angular distance of a star measured eastward along the celestial equator from the vernal equinox.
    field :right_ascension, :float

    # Right Ascension in degrees. Calculated as right_ascension (in hours) × 15.
    # Unit: Degrees
    # Description: The angular distance of a star measured eastward along the celestial equator from the vernal equinox, expressed in degrees.
    field :right_ascension_degrees, :float, virtual: true

    # Declination in degrees. Source: HYG 'dec' column.
    # Unit: Degrees
    # Description: The angular distance of a star north or south of the celestial equator.
    field :declination, :float

    # Distance from Earth. Source: HYG 'dist' column.
    # Unit: Parsecs
    # Description: The distance of the star from Earth measured in parsecs (1 parsec ≈ 3.26 light-years).
    field :distance_parsecs, :float

    # Proper motion in Right Ascension. Source: HYG 'pmra' column.
    # Unit: Milliarcseconds/year
    # Description: The rate at which the star appears to move eastward across the sky.
    field :proper_motion_ra, :float

    # Proper motion in Declination. Source: HYG 'pmdec' column.
    # Unit: Milliarcseconds/year
    # Description: The rate at which the star appears to move northward or southward across the sky.
    field :proper_motion_dec, :float

    # Radial Velocity. Source: HYG 'rv' column.
    # Unit: Kilometers/second
    # Description: The speed at which the star is moving toward or away from Earth.
    field :radial_velocity, :float

    # Apparent Magnitude. Source: HYG 'mag' column.
    # Unit: Magnitude
    # Description: How bright the star appears from Earth, with lower numbers indicating brighter stars.
    field :apparent_magnitude, :float

    # Absolute Magnitude. Source: HYG 'absmag' column.
    # Unit: Magnitude
    # Description: The intrinsic brightness of the star, measured as how bright it would appear at a standard distance of 10 parsecs.
    field :absolute_magnitude, :float

    # Spectral Type. Source: HYG 'spect' column.
    # Description: Classification of the star based on its temperature and other spectral characteristics (e.g., "G2V" for the Sun).
    field :spectral_type, :string
    
    # Generic Spectral Type. Derived from the first character of the spectral_type field.
    # Description: The main spectral class (O, B, A, F, G, K, M, etc.) without subclass information.
    field :spectral_type_generic, :string

    # Color Index (B-V). Source: HYG 'ci' column.
    # Description: A measure of the star's color, which relates to its temperature; higher values indicate redder stars.
    field :color_index, :float

    # Cartesian X coordinate. Source: HYG 'x' column.
    # Unit: Parsecs
    # Description: The star's position along the X-axis in a three-dimensional Cartesian coordinate system centered at the Sun.
    field :x, :float

    # Cartesian Y coordinate. Source: HYG 'y' column.
    # Unit: Parsecs
    # Description: The star's position along the Y-axis in a three-dimensional Cartesian coordinate system centered at the Sun.
    field :y, :float

    # Cartesian Z coordinate. Source: HYG 'z' column.
    # Unit: Parsecs
    # Description: The star's position along the Z-axis in a three-dimensional Cartesian coordinate system centered at the Sun.
    field :z, :float

    # Luminosity relative to the Sun. Source: HYG 'lum' column.
    # Description: The brightness of the star compared to the Sun; a value of 1.0 means equal luminosity.
    field :luminosity, :float

    # Variable Star Type. Source: HYG 'var' column.
    # Description: Indicates if the star's brightness varies over time and the type of variability.
    field :variable_type, :string

    # Minimum Apparent Magnitude for Variable Stars. Source: HYG 'var_min' column.
    # Unit: Magnitude
    # Description: The faintest brightness the star reaches during its variability cycle.
    field :variable_min, :float

    # Maximum Apparent Magnitude for Variable Stars. Source: HYG 'var_max' column.
    # Unit: Magnitude
    # Description: The brightest brightness the star reaches during its variability cycle.
    field :variable_max, :float

    # Constellation Abbreviation. Source: HYG 'con' column.
    # Description: The standard three-letter abbreviation of the constellation where the star is located (e.g., "Ori" for Orion).
    field :constellation, :string

    # Relationship to Star System
    belongs_to :star_system, StarChart.Astronomy.StarSystem

    timestamps()
  end

  @doc false
  def changeset(star, attrs) do
    star
    |> cast(attrs, [
      :name,
      :proper_name,
      :is_primary,
      :hip,
      :hd,
      :hr,
      :gl,
      :bayer_flamsteed,
      :right_ascension,
      :declination,
      :distance_parsecs,
      :proper_motion_ra,
      :proper_motion_dec,
      :radial_velocity,
      :apparent_magnitude,
      :absolute_magnitude,
      :spectral_type,
      :spectral_type_generic,
      :color_index,
      :x,
      :y,
      :z,
      :luminosity,
      :variable_type,
      :variable_min,
      :variable_max,
      :constellation,
      :star_system_id
    ])
    |> validate_required([
      :name,
      :is_primary,
      :right_ascension,
      :declination,
      :distance_parsecs,
      :x,
      :y,
      :z,
      :spectral_type_generic,
      :star_system_id
    ])
    |> foreign_key_constraint(:star_system_id)
  end

  def with_virtual_fields(star) do
    %{star | right_ascension_degrees: right_ascension_degrees(star)}
  end

  @doc """
  Calculates the right ascension in degrees from the right ascension in hours.
  """
  def right_ascension_degrees(%StarChart.Astronomy.Star{right_ascension: right_ascension})
      when is_number(right_ascension) do
    StarChart.Astronomy.Utils.hours_to_degrees(right_ascension)
  end

  def right_ascension_degrees(_), do: nil
end

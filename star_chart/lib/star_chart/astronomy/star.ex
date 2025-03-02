defmodule StarChart.Astronomy.Star do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stars" do
    field :name, :string
    field :proper_name, :string
    field :is_primary, :boolean, default: false
    field :hip, :integer
    field :hd, :integer
    field :hr, :integer
    field :gl, :string
    field :bayer_flamsteed, :string
    field :right_ascension, :float
    field :right_ascension_degrees, :float
    field :declination, :float
    field :distance_parsecs, :float
    field :proper_motion_ra, :float
    field :proper_motion_dec, :float
    field :radial_velocity, :float
    field :apparent_magnitude, :float
    field :absolute_magnitude, :float
    field :spectral_type, :string
    field :color_index, :float
    field :x, :float
    field :y, :float
    field :z, :float
    field :luminosity, :float
    field :variable_type, :string
    field :variable_min, :float
    field :variable_max, :float
    field :constellation, :string
    
    # Add the relationship to star_system
    belongs_to :star_system, StarChart.Astronomy.StarSystem

    timestamps()
  end

  @doc false
  def changeset(star, attrs) do
    star
    |> cast(attrs, [
      :name, :proper_name, :is_primary, :hip, :hd, :hr, :gl, :bayer_flamsteed,
      :right_ascension, :right_ascension_degrees, :declination, :distance_parsecs,
      :proper_motion_ra, :proper_motion_dec, :radial_velocity,
      :apparent_magnitude, :absolute_magnitude, :spectral_type,
      :color_index, :x, :y, :z, :luminosity,
      :variable_type, :variable_min, :variable_max,
      :constellation, :star_system_id
    ])
    |> validate_required([
      :name, :is_primary, :right_ascension, :right_ascension_degrees, :declination, 
      :distance_parsecs, :x, :y, :z, :star_system_id
    ])
    |> foreign_key_constraint(:star_system_id)
  end
end

defmodule StarChart.Repo.Migrations.CreateStarSystemsAndStars do
  use Ecto.Migration

  def change do
    # Enable the cube extension for advanced spatial indexing
    execute "CREATE EXTENSION IF NOT EXISTS cube"

    # Drop existing tables if they exist
    drop_if_exists table(:star_systems)

    # Create star_systems table
    create table(:star_systems) do
      add :name, :string, null: false

      timestamps()
    end

    create index(:star_systems, [:name])

    # Create stars table
    create table(:stars) do
      add :star_system_id, references(:star_systems, on_delete: :delete_all)
      add :name, :string, null: false
      add :proper_name, :string
      add :is_primary, :boolean, default: false
      add :hip, :integer
      add :hd, :integer
      add :hr, :integer
      add :gl, :string
      add :bayer_flamsteed, :string
      add :right_ascension, :float, null: false
      add :declination, :float, null: false
      add :distance_parsecs, :float, null: false
      add :proper_motion_ra, :float, null: false
      add :proper_motion_dec, :float, null: false
      add :radial_velocity, :float, null: false
      add :apparent_magnitude, :float, null: false
      add :absolute_magnitude, :float, null: false
      add :spectral_type, :string
      add :color_index, :float
      add :x, :float, null: false
      add :y, :float, null: false
      add :z, :float, null: false
      add :luminosity, :float, null: false
      add :variable_type, :string
      add :variable_min, :float
      add :variable_max, :float
      add :constellation, :string

      timestamps()
    end

    create index(:stars, [:star_system_id])
    create index(:stars, [:name])
    create index(:stars, [:proper_name])
    create index(:stars, [:hip])
    create index(:stars, [:hd])
    create index(:stars, [:is_primary])

    # Create a GiST index on the 3D coordinates using the cube extension
    execute "CREATE INDEX stars_position_idx ON stars USING gist (cube(array[x, y, z]))"
  end
end

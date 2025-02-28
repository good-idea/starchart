defmodule StarChart.Repo.Migrations.CreateStarSystems do
  use Ecto.Migration

  def change do
    create table(:star_systems) do
      add :name, :string
      add :distance_light_years, :float
      add :spectral_type, :string
      add :description, :text

      timestamps()
    end
  end
end
defmodule StarChart.Repo.Migrations.CreateStarSystems do
  use Ecto.Migration

  def change do
    create table(:star_systems) do
      add :name, :string
      add :distance_light_years, :float
      add :spectral_type, :string
      add :description, :text

      timestamps()
    end
  end
end

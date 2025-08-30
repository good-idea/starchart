defmodule StarChart.Repo.Migrations.CreateStarships do
  use Ecto.Migration

  def change do
    create table(:starships) do
      add :name, :string, null: false
      add :max_jump_distance, :float, default: 25.0, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :star_system_id, references(:star_systems, on_delete: :restrict), null: false

      timestamps()
    end

    create index(:starships, [:user_id])
    create index(:starships, [:star_system_id])
    create index(:starships, [:name])
  end
end

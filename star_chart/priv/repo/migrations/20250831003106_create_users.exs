defmodule StarChart.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :username, :string, null: false
      add :confirmed_at, :naive_datetime
      add :last_login_at, :naive_datetime

      timestamps()
    end

    # Create unique indexes for email and username
    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end

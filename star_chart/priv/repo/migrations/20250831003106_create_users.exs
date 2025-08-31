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

    # Create tokens table for magic link authentication
    create table(:tokens) do
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :inserted_at, :naive_datetime, null: false
    end

    # Create indexes for tokens
    create index(:tokens, [:user_id])
    create unique_index(:tokens, [:token, :context])
  end
end

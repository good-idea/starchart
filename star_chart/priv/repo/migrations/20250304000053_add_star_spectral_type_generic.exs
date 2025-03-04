defmodule StarChart.Repo.Migrations.AddStarSpectralTypeGeneric do
  use Ecto.Migration

  def change do
    alter table(:stars) do
      add :spectral_type_generic, :string, size: 1, null: false
    end
  end
end

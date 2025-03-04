defmodule StarChart.Repo.Migrations.AddStarSpectralTypeGeneric do
  use Ecto.Migration

  def change do
    alter table(:stars) do
      add :spectral_class, :string, size: 1, null: false
      modify :spectral_type, :string, null: false
    end
  end
end

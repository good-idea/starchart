defmodule StarChart.Astronomy.StarSystem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "star_systems" do
    field :name, :string
    field :distance_light_years, :float
    field :spectral_type, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(star_system, attrs) do
    star_system
    |> cast(attrs, [:name, :distance_light_years, :spectral_type, :description])
    |> validate_required([:name, :distance_light_years, :spectral_type, :description])
  end
end
defmodule StarChart.Astronomy.StarSystem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "star_systems" do
    field :name, :string
    field :distance_light_years, :float
    field :spectral_type, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(star_system, attrs) do
    star_system
    |> cast(attrs, [:name, :distance_light_years, :spectral_type, :description])
    |> validate_required([:name, :distance_light_years, :spectral_type, :description])
  end
end

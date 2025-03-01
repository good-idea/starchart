defmodule StarChart.Astronomy.StarSystem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "star_systems" do
    field :name, :string

    # Add the relationship to stars
    has_many :stars, StarChart.Astronomy.Star

    timestamps()
  end

  @doc false
  def changeset(star_system, attrs) do
    star_system
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

defmodule StarChart.Accounts.Starship do
  use Ecto.Schema
  import Ecto.Changeset

  schema "starships" do
    field :name, :string
    field :max_jump_distance, :float, default: 25.0

    belongs_to :user, StarChart.Accounts.User
    belongs_to :star_system, StarChart.Astronomy.StarSystem

    timestamps()
  end

  @doc false
  def changeset(starship, attrs) do
    starship
    |> cast(attrs, [:name, :max_jump_distance, :user_id, :star_system_id])
    |> validate_required([:name, :max_jump_distance, :user_id, :star_system_id])
    |> validate_number(:max_jump_distance, greater_than: 0)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:star_system_id)
  end
end

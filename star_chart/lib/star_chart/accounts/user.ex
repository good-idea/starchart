defmodule StarChart.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :confirmed_at, :naive_datetime
    field :last_login_at, :naive_datetime

    timestamps()
  end

  @doc """
  Changeset for creating a new user.
  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username])
    |> validate_required([:email, :username])
    |> validate_email()
    |> validate_username()
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  @doc """
  Changeset for updating a user's last login time.
  """
  def login_changeset(user) do
    change(user, last_login_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
  end

  @doc """
  Changeset for confirming a user's email.
  """
  def confirm_changeset(user) do
    change(user, confirmed_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
  end

  defp validate_email(changeset) do
    changeset
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end

  defp validate_username(changeset) do
    changeset
    |> validate_format(:username, ~r/^[a-zA-Z0-9_-]+$/, 
       message: "only letters, numbers, underscores, and hyphens allowed")
    |> validate_length(:username, min: 3, max: 30)
  end
end

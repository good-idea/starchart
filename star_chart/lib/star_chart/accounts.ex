defmodule StarChart.Accounts do
  @moduledoc """
  The Accounts context.
  Contains functions for managing user accounts and their starships.
  """

  import Ecto.Query, warn: false
  alias StarChart.Repo
  alias StarChart.Accounts.{User, Starship}

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Returns `nil` if the User does not exist.
  """
  def get_user(id) do
    Repo.get(User, id)
  end

  @doc """
  Gets a single user.
  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user!(id) do
    Repo.get!(User, id)
  end

  @doc """
  Gets a user by username.

  Returns `nil` if the User does not exist.
  """
  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns the list of starships.
  """
  def list_starships do
    Starship
    |> Repo.all()
    |> Repo.preload([:user, :star_system])
  end

  @doc """
  Returns the list of starships for a specific user.
  """
  def list_starships_by_user(user_id) do
    Starship
    |> where(user_id: ^user_id)
    |> Repo.all()
    |> Repo.preload([:user, :star_system])
  end

  @doc """
  Gets a single starship.

  Returns `nil` if the Starship does not exist.
  """
  def get_starship(id) do
    Starship
    |> Repo.get(id)
    |> Repo.preload([:user, :star_system])
  end

  @doc """
  Gets a single starship.
  Raises `Ecto.NoResultsError` if the Starship does not exist.
  """
  def get_starship!(id) do
    Starship
    |> Repo.get!(id)
    |> Repo.preload([:user, :star_system])
  end

  @doc """
  Creates a starship.
  """
  def create_starship(attrs \\ %{}) do
    %Starship{}
    |> Starship.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a starship.
  """
  def update_starship(%Starship{} = starship, attrs) do
    starship
    |> Starship.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a starship.
  """
  def delete_starship(%Starship{} = starship) do
    Repo.delete(starship)
  end
end
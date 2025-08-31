defmodule StarChart.Accounts do
  @moduledoc """
  The Accounts context.
  Handles user management and authentication.
  """

  import Ecto.Query, warn: false
  alias StarChart.Repo
  alias StarChart.Accounts.User

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user by ID.
  Returns nil if the User does not exist.
  """
  def get_user(id) do
    Repo.get(User, id)
  end

  @doc """
  Gets a single user by email.
  Returns nil if the User does not exist.
  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a single user by username.
  Returns nil if the User does not exist.
  """
  def get_user_by_username(username) when is_binary(username) do
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
  Marks a user as confirmed.
  """
  def confirm_user(%User{} = user) do
    user
    |> User.confirm_changeset()
    |> Repo.update()
  end

  @doc """
  Updates the user's last login timestamp.
  """
  def log_user_login(%User{} = user) do
    user
    |> User.login_changeset()
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end

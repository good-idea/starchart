defmodule StarChart.Accounts do
  @moduledoc """
  The Accounts context.
  Handles user management and authentication.
  """

  import Ecto.Query, warn: false
  alias StarChart.Repo
  alias StarChart.Accounts.{User, Token}
  alias StarChart.Mailer

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

  @doc """
  Creates a magic link token for a user.
  """
  def create_magic_link_token(%User{} = user) do
    {encoded_token, token} = generate_token()
    
    # Create a token record
    token_attrs = %{
      token: token,
      context: "magic_link",
      sent_to: user.email,
      user_id: user.id,
      inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    }
    
    %Token{}
    |> Token.changeset(token_attrs)
    |> Repo.insert()
    
    encoded_token
  end

  @doc """
  Delivers a magic link to the user.
  """
  def deliver_magic_link(%User{} = user) do
    encoded_token = create_magic_link_token(user)
    
    # Send the email with the magic link
    StarChart.Email.magic_link(user, encoded_token)
    |> Mailer.deliver()
    
    {:ok, encoded_token}
  end

  @doc """
  Verifies a magic link token.
  """
  def verify_magic_link_token(token) do
    with {:ok, decoded_token} <- decode_token(token),
         %Token{user_id: user_id} = token_record <- get_valid_token(decoded_token, "magic_link"),
         %User{} = user <- get_user(user_id) do
      # Delete the token to prevent reuse
      Repo.delete(token_record)
      
      # Update the user's last login timestamp
      {:ok, user} = log_user_login(user)
      
      {:ok, user}
    else
      _ -> {:error, :invalid_token}
    end
  end

  # Private functions

  defp get_valid_token(token, context) do
    query = Token.verify_email_token_query(token, context)
    Repo.one(query)
  end

  defp generate_token do
    token = :crypto.strong_rand_bytes(32)
    encoded_token = Base.url_encode64(token, padding: false)
    {encoded_token, token}
  end

  defp decode_token(encoded_token) do
    case Base.url_decode64(encoded_token, padding: false) do
      {:ok, token} -> {:ok, token}
      :error -> {:error, :invalid_token}
    end
  end
end

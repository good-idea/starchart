defmodule StarChart.Accounts.Token do
  @moduledoc """
  Token schema for magic link authentication.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias StarChart.Accounts.User

  @rand_size 32
  @token_validity_in_days 1

  schema "tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :user, User

    field :inserted_at, :naive_datetime
  end

  @doc """
  Generates a token for the specified user and context.
  """
  def build_email_token(user, context) do
    token = :crypto.strong_rand_bytes(@rand_size)
    
    %__MODULE__{
      token: token,
      context: context,
      sent_to: user.email,
      user_id: user.id,
      inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    }
  end

  @doc """
  Validates the token changeset.
  """
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :context, :sent_to, :user_id, :inserted_at])
    |> validate_required([:token, :context, :user_id, :inserted_at])
    |> foreign_key_constraint(:user_id)
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.
  """
  def verify_email_token_query(token, context) do
    from token in token_query(token, context),
      where: token.inserted_at > ago(@token_validity_in_days, "day")
  end

  @doc """
  Returns the token struct for the given token value and context.
  """
  def token_query(token, context) do
    from t in __MODULE__,
      where: t.token == ^token and t.context == ^context
  end
end

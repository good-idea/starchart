defmodule StarChart.Accounts.TokenTest do
  use StarChart.DataCase
  alias StarChart.Accounts.Token
  alias StarChart.Accounts.User

  setup do
    {:ok, user} = StarChart.Repo.insert(%User{
      email: "token-test@example.com",
      username: "tokentest"
    })
    %{user: user}
  end

  describe "Token" do
    test "build_email_token/2 creates a token for a user", %{user: user} do
      token = Token.build_email_token(user, "magic_link")
      
      assert token.user_id == user.id
      assert token.context == "magic_link"
      assert token.sent_to == user.email
      assert is_binary(token.token)
      assert byte_size(token.token) == 32
      assert token.inserted_at != nil
    end

    test "changeset/2 validates required fields", %{user: user} do
      token = Token.build_email_token(user, "magic_link")
      
      # Valid changeset
      changeset = Token.changeset(token, %{})
      assert changeset.valid?
      
      # Invalid changeset - missing token
      changeset = Token.changeset(%Token{}, %{
        context: "magic_link",
        user_id: user.id,
        inserted_at: NaiveDateTime.utc_now()
      })
      refute changeset.valid?
    end

    test "token_query/2 returns the correct query", %{user: user} do
      token_binary = :crypto.strong_rand_bytes(32)
      context = "magic_link"
      
      # Insert a token
      {:ok, token} = %Token{
        token: token_binary,
        context: context,
        user_id: user.id,
        sent_to: user.email,
        inserted_at: NaiveDateTime.utc_now()
      } |> Repo.insert()
      
      # Query for the token
      query = Token.token_query(token_binary, context)
      result = Repo.one(query)
      
      assert result.id == token.id
    end

    test "verify_email_token_query/2 returns valid tokens", %{user: user} do
      token_binary = :crypto.strong_rand_bytes(32)
      context = "magic_link"
      
      # Insert a token
      {:ok, token} = %Token{
        token: token_binary,
        context: context,
        user_id: user.id,
        sent_to: user.email,
        inserted_at: NaiveDateTime.utc_now()
      } |> Repo.insert()
      
      # Query for the token
      query = Token.verify_email_token_query(token_binary, context)
      result = Repo.one(query)
      
      assert result.id == token.id
    end

    test "verify_email_token_query/2 doesn't return expired tokens", %{user: user} do
      token_binary = :crypto.strong_rand_bytes(32)
      context = "magic_link"
      
      # Insert an expired token (2 days old)
      expired_date = NaiveDateTime.utc_now() |> NaiveDateTime.add(-2, :day)
      
      {:ok, _token} = %Token{
        token: token_binary,
        context: context,
        user_id: user.id,
        sent_to: user.email,
        inserted_at: expired_date
      } |> Repo.insert()
      
      # Query for the token
      query = Token.verify_email_token_query(token_binary, context)
      result = Repo.one(query)
      
      assert result == nil
    end
  end
end

defmodule StarChart.AccountsTest do
  use StarChart.DataCase
  import StarChart.Factory
  alias StarChart.Accounts
  alias StarChart.Accounts.{User, Token}
  alias StarChart.Mailer
  import Swoosh.TestAssertions

  describe "users" do
    @valid_attrs %{
      "email" => "test@example.com",
      "username" => "testuser"
    }
    @invalid_attrs %{
      "email" => "invalid-email",
      "username" => "a"
    }

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "test@example.com"
      assert user.username == "testuser"
      assert user.confirmed_at == nil
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with duplicate email returns error" do
      {:ok, _user} = Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@valid_attrs)
    end

    test "get_user/1 returns the user with given id" do
      {:ok, user} = Accounts.create_user(@valid_attrs)
      assert %User{id: id} = Accounts.get_user(user.id)
      assert id == user.id
    end

    test "get_user/1 returns nil for invalid id" do
      assert Accounts.get_user(999) == nil
    end

    test "get_user_by_email/1 returns the user with given email" do
      {:ok, user} = Accounts.create_user(@valid_attrs)
      assert %User{id: id} = Accounts.get_user_by_email(user.email)
      assert id == user.id
    end

    test "get_user_by_email/1 returns nil for invalid email" do
      assert Accounts.get_user_by_email("nonexistent@example.com") == nil
    end
  end

  describe "tokens" do
    setup do
      {:ok, user} = Accounts.create_user(%{
        "email" => "token-test@example.com",
        "username" => "tokenuser"
      })
      %{user: user}
    end

    test "deliver_magic_link/1 creates a token and sends an email", %{user: user} do
      assert {:ok, token} = Accounts.deliver_magic_link(user)
      assert is_binary(token)
      
      # Verify email was sent
      assert_email_sent to: {user.username, user.email}
    end

    test "verify_magic_link_token/1 with valid token returns the user", %{user: user} do
      {:ok, token} = Accounts.deliver_magic_link(user)
      assert {:ok, verified_user} = Accounts.verify_magic_link_token(token)
      assert verified_user.id == user.id
      
      # Verify last_login_at was updated
      assert verified_user.last_login_at != nil
    end

    test "verify_magic_link_token/1 with invalid token returns error" do
      assert {:error, :invalid_token} = Accounts.verify_magic_link_token("invalid-token")
    end

    test "verify_magic_link_token/1 with expired token returns error", %{user: user} do
      # Create a token that's already expired
      token = Token.build_email_token(user, "magic_link")
      expired_date = NaiveDateTime.utc_now() |> NaiveDateTime.add(-2, :day)
      token = %{token | inserted_at: expired_date}
      
      # Insert the expired token
      Repo.insert!(token)
      
      # Encode the token for verification
      encoded_token = Base.url_encode64(token.token)
      
      # Verify it returns an error
      assert {:error, :invalid_token} = Accounts.verify_magic_link_token(encoded_token)
    end
  end
end

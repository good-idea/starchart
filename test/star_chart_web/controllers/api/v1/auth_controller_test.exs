defmodule StarChartWeb.API.V1.AuthControllerTest do
  use StarChartWeb.ConnCase
  alias StarChart.Accounts
  alias StarChart.Accounts.User
  import Swoosh.TestAssertions

  @valid_user %{
    "email" => "test@example.com",
    "username" => "testuser"
  }
  @invalid_user %{
    "email" => "invalid-email",
    "username" => "a"
  }

  describe "register/2" do
    test "registers a user with valid data", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/auth/register", @valid_user)
      
      assert %{"message" => message} = json_response(conn, 201)
      assert message =~ "User created successfully"
      
      # Verify user was created in the database
      user = Accounts.get_user_by_email(@valid_user["email"])
      assert user != nil
      assert user.username == @valid_user["username"]
      
      # Verify email was sent
      assert_email_sent to: {user.username, user.email}
    end

    test "returns error with invalid data", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/auth/register", @invalid_user)
      
      assert %{"errors" => %{"detail" => _}} = json_response(conn, 400)
    end

    test "returns error when email already exists", %{conn: conn} do
      # Create a user first
      {:ok, _user} = Accounts.create_user(@valid_user)
      
      # Try to register with the same email
      conn = post(conn, ~p"/api/v1/auth/register", @valid_user)
      
      assert %{"errors" => %{"detail" => _}} = json_response(conn, 422)
    end
  end

  describe "login/2" do
    setup do
      {:ok, user} = Accounts.create_user(@valid_user)
      %{user: user}
    end

    test "sends magic link for existing user", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/v1/auth/login", %{"email" => user.email})
      
      assert %{"message" => message} = json_response(conn, 200)
      assert message =~ "Magic link sent"
      
      # Verify email was sent
      assert_email_sent to: {user.username, user.email}
    end

    test "returns success for non-existent email (security)", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/auth/login", %{"email" => "nonexistent@example.com"})
      
      assert %{"message" => message} = json_response(conn, 200)
      assert message =~ "Magic link sent"
      
      # Verify no email was sent
      refute_email_sent to: {"", "nonexistent@example.com"}
    end

    test "returns error with invalid email format", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/auth/login", %{"email" => "invalid-email"})
      
      assert %{"errors" => %{"detail" => _}} = json_response(conn, 400)
    end
  end

  describe "verify/2" do
    setup do
      {:ok, user} = Accounts.create_user(@valid_user)
      {:ok, token} = Accounts.deliver_magic_link(user)
      %{user: user, token: token}
    end

    test "verifies valid token and returns session", %{conn: conn, user: user, token: token} do
      conn = get(conn, ~p"/api/v1/auth/verify/#{token}")
      
      assert %{
        "message" => "Login successful",
        "token" => session_token,
        "user" => %{"id" => id, "email" => email, "username" => username}
      } = json_response(conn, 200)
      
      assert id == user.id
      assert email == user.email
      assert username == user.username
      assert is_binary(session_token)
      
      # Verify authorization header was set
      assert [bearer_token] = get_resp_header(conn, "authorization")
      assert bearer_token == "Bearer #{session_token}"
    end

    test "returns error for invalid token", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/auth/verify/invalid-token")
      
      assert %{"errors" => %{"detail" => message}} = json_response(conn, 401)
      assert message =~ "Invalid or expired token"
    end
  end

  describe "logout/2" do
    setup %{conn: conn} do
      # Create a user and generate a session token
      {:ok, user} = Accounts.create_user(@valid_user)
      session_token = Phoenix.Token.sign(StarChartWeb.Endpoint, "user auth", user.id)
      
      # Create an authenticated conn
      authed_conn = conn
      |> put_req_header("authorization", "Bearer #{session_token}")
      
      %{conn: authed_conn, user: user}
    end

    test "logs out successfully", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/auth/logout")
      
      assert %{"message" => message} = json_response(conn, 200)
      assert message =~ "Logged out successfully"
    end
  end
end

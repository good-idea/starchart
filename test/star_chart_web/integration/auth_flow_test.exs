defmodule StarChartWeb.Integration.AuthFlowTest do
  use StarChartWeb.ConnCase
  alias StarChart.Accounts
  import Swoosh.TestAssertions

  @valid_user %{
    "email" => "integration@example.com",
    "username" => "integrationuser"
  }

  describe "complete authentication flow" do
    test "register, login, access protected resource, and logout", %{conn: conn} do
      # Step 1: Register a new user
      conn = post(conn, ~p"/api/v1/auth/register", @valid_user)
      assert %{"message" => _} = json_response(conn, 201)
      
      # Verify email was sent
      user = Accounts.get_user_by_email(@valid_user["email"])
      assert user != nil
      assert_email_sent to: {user.username, user.email}
      
      # Extract the token from the email
      email = Swoosh.Adapters.Local.Storage.Memory.get_latest_email()
      [_, token] = Regex.run(~r{/api/auth/magic-link/([^"]+)}, email.html_body)
      
      # Step 2: Verify the magic link token
      conn = get(conn, ~p"/api/v1/auth/verify/#{token}")
      assert %{"token" => session_token} = json_response(conn, 200)
      
      # Step 3: Access a protected resource
      conn = conn
      |> recycle()
      |> put_req_header("authorization", "Bearer #{session_token}")
      |> get(~p"/api/v1/user/profile")
      
      assert %{"data" => %{"id" => id}} = json_response(conn, 200)
      assert id == user.id
      
      # Step 4: Logout
      conn = conn
      |> recycle()
      |> put_req_header("authorization", "Bearer #{session_token}")
      |> post(~p"/api/v1/auth/logout")
      
      assert %{"message" => message} = json_response(conn, 200)
      assert message =~ "Logged out successfully"
    end
  end
end

defmodule StarChartWeb.API.V1.UserControllerTest do
  use StarChartWeb.ConnCase
  alias StarChart.Accounts

  @valid_user %{
    "email" => "test@example.com",
    "username" => "testuser"
  }

  setup %{conn: conn} do
    # Create a user
    {:ok, user} = Accounts.create_user(@valid_user)
    
    # Generate a session token
    session_token = Phoenix.Token.sign(StarChartWeb.Endpoint, "user auth", user.id)
    
    # Create an authenticated conn
    authed_conn = conn
    |> put_req_header("authorization", "Bearer #{session_token}")
    
    %{conn: conn, authed_conn: authed_conn, user: user}
  end

  describe "profile/2" do
    test "returns user profile when authenticated", %{authed_conn: conn, user: user} do
      conn = get(conn, ~p"/api/v1/user/profile")
      
      assert %{
        "data" => %{
          "id" => id,
          "email" => email,
          "username" => username,
          "confirmed_at" => nil,
          "last_login_at" => nil
        }
      } = json_response(conn, 200)
      
      assert id == user.id
      assert email == user.email
      assert username == user.username
    end

    test "returns unauthorized when not authenticated", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/user/profile")
      
      assert %{"errors" => %{"detail" => message}} = json_response(conn, 401)
      assert message =~ "Unauthorized"
    end

    test "returns unauthorized with invalid token", %{conn: conn} do
      conn = conn
      |> put_req_header("authorization", "Bearer invalid-token")
      |> get(~p"/api/v1/user/profile")
      
      assert %{"errors" => %{"detail" => message}} = json_response(conn, 401)
      assert message =~ "Unauthorized"
    end
  end
end

defmodule StarChartWeb.Plugs.AuthPlugTest do
  use StarChartWeb.ConnCase
  alias StarChartWeb.Plugs.AuthPlug
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
    
    %{conn: conn, user: user, token: session_token}
  end

  test "init/1 returns options", %{conn: _conn} do
    assert AuthPlug.init([]) == []
  end

  test "call/2 assigns current_user with valid token", %{conn: conn, user: user, token: token} do
    conn = conn
    |> put_req_header("authorization", "Bearer #{token}")
    |> AuthPlug.call([])
    
    assert conn.assigns.current_user.id == user.id
    assert conn.status != 401
  end

  test "call/2 returns 401 with missing token", %{conn: conn} do
    conn = AuthPlug.call(conn, [])
    
    assert conn.status == 401
    assert conn.halted
    assert conn.resp_body =~ "Unauthorized"
  end

  test "call/2 returns 401 with invalid token", %{conn: conn} do
    conn = conn
    |> put_req_header("authorization", "Bearer invalid-token")
    |> AuthPlug.call([])
    
    assert conn.status == 401
    assert conn.halted
    assert conn.resp_body =~ "Unauthorized"
  end

  test "call/2 returns 401 with expired token", %{conn: conn, user: user} do
    # Generate an expired token (30 days + 1 second old)
    expired_token = Phoenix.Token.sign(
      StarChartWeb.Endpoint,
      "user auth",
      user.id,
      max_age: -1
    )
    
    conn = conn
    |> put_req_header("authorization", "Bearer #{expired_token}")
    |> AuthPlug.call([])
    
    assert conn.status == 401
    assert conn.halted
    assert conn.resp_body =~ "Unauthorized"
  end
end

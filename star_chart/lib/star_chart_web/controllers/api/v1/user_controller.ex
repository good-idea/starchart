defmodule StarChartWeb.API.V1.UserController do
  use StarChartWeb, :controller

  @doc """
  Get the current user's profile.
  """
  def profile(conn, _params) do
    user = conn.assigns.current_user

    json(conn, %{
      data: %{
        id: user.id,
        email: user.email,
        username: user.username,
        confirmed_at: user.confirmed_at,
        last_login_at: user.last_login_at
      }
    })
  end
end

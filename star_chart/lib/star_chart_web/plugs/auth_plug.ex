defmodule StarChartWeb.Plugs.AuthPlug do
  @moduledoc """
  Plug for authenticating requests using JWT tokens.
  """
  import Plug.Conn
  alias StarChart.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user_id} <- verify_token(token),
         user when not is_nil(user) <- Accounts.get_user(user_id) do
      # Store the user in the connection assigns
      assign(conn, :current_user, user)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{errors: %{detail: "Unauthorized"}})
        |> halt()
    end
  end

  defp verify_token(token) do
    Phoenix.Token.verify(
      StarChartWeb.Endpoint,
      "user auth",
      token,
      max_age: 86400 * 30 # 30 days
    )
  end
end

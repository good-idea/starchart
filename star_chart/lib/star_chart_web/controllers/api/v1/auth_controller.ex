defmodule StarChartWeb.API.V1.AuthController do
  use StarChartWeb, :controller
  alias StarChart.Accounts
  alias StarChartWeb.Utils.Params

  @doc """
  Register a new user.
  """
  def register(conn, params) do
    schema = %{
      "email" => %{type: :string, required: true},
      "username" => %{type: :string, required: true}
    }

    with {:ok, validated_params} <- Params.validate_params(params, schema),
         {:ok, user} <- Accounts.create_user(validated_params) do
      # Send a magic link to the user
      {:ok, _token} = Accounts.deliver_magic_link(user)

      conn
      |> put_status(:created)
      |> json(%{
        message: "User created successfully. Check your email for a magic link to log in."
      })
    else
      {:error, {field, message}} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: %{detail: "#{field} #{message}"}})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(StarChartWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)
    end
  end

  @doc """
  Send a magic link to an existing user.
  """
  def login(conn, params) do
    schema = %{
      "email" => %{type: :string, required: true}
    }

    with {:ok, %{"email" => email}} <- Params.validate_params(params, schema),
         %StarChart.Accounts.User{} = user <- Accounts.get_user_by_email(email) do
      # Send a magic link to the user
      {:ok, _token} = Accounts.deliver_magic_link(user)

      conn
      |> json(%{
        message: "Magic link sent. Check your email to log in."
      })
    else
      {:error, {field, message}} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: %{detail: "#{field} #{message}"}})

      nil ->
        # Don't reveal that the email doesn't exist for security reasons
        # Just pretend we sent the email
        conn
        |> json(%{
          message: "Magic link sent. Check your email to log in."
        })
    end
  end

  @doc """
  Verify a magic link token and log the user in.
  """
  def verify(conn, %{"token" => token}) do
    case Accounts.verify_magic_link_token(token) do
      {:ok, user} ->
        # Generate a session token
        session_token = Phoenix.Token.sign(
          StarChartWeb.Endpoint,
          "user auth",
          user.id
        )

        conn
        |> put_resp_header("authorization", "Bearer #{session_token}")
        |> json(%{
          message: "Login successful",
          token: session_token,
          user: %{
            id: user.id,
            email: user.email,
            username: user.username
          }
        })

      {:error, :invalid_token} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{
          errors: %{detail: "Invalid or expired token"}
        })
    end
  end

  @doc """
  Log out the current user.
  """
  def logout(conn, _params) do
    conn
    |> json(%{
      message: "Logged out successfully"
    })
  end
end

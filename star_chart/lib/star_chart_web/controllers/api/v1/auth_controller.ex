defmodule StarChartWeb.API.V1.AuthController do
  use StarChartWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias StarChart.Accounts
  alias StarChartWeb.Utils.Params
  alias StarChartWeb.Schema

  # Define constants for response messages
  @registration_success_message "User created successfully. Check your email for a magic link to log in."
  @magic_link_sent_message "Magic link sent. Check your email to log in."
  @login_success_message "Login successful"
  @invalid_token_message "Invalid or expired token"
  @logout_success_message "Logged out successfully"

  tags(["Authentication"])

  operation(:register,
    summary: "Register a new user",
    description: "Creates a new user account and sends a magic link for authentication",
    request_body: {"User registration", "application/json", Schema.UserRegistrationRequest, required: true},
    responses: [
      created: {"Registration successful", "application/json", %OpenApiSpex.Schema{
        type: :object,
        properties: %{
          message: %OpenApiSpex.Schema{type: :string, example: @registration_success_message}
        },
        required: [:message]
      }},
      bad_request: {"Bad request", "application/json", Schema.ErrorResponse},
      unprocessable_entity: {"Validation error", "application/json", Schema.ErrorResponse}
    ]
  )

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
        message: @registration_success_message
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

  operation(:login,
    summary: "Login with email",
    description: "Sends a magic link to the user's email for authentication",
    request_body: {"Login request", "application/json", Schema.LoginRequest, required: true},
    responses: [
      ok: {"Login email sent", "application/json", %OpenApiSpex.Schema{
        type: :object,
        properties: %{
          message: %OpenApiSpex.Schema{type: :string, example: @magic_link_sent_message}
        },
        required: [:message]
      }},
      bad_request: {"Bad request", "application/json", Schema.ErrorResponse}
    ]
  )

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
        message: @magic_link_sent_message
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
          message: @magic_link_sent_message
        })
    end
  end

  operation(:verify,
    summary: "Verify magic link token",
    description: "Verifies a magic link token and returns a session token if valid",
    parameters: [
      token: [in: :path, description: "Magic link token", type: :string, example: "abc123"]
    ],
    responses: [
      ok: {"Login successful", "application/json", Schema.SessionResponse},
      unauthorized: {"Unauthorized", "application/json", %OpenApiSpex.Schema{
        type: :object,
        properties: %{
          errors: %OpenApiSpex.Schema{
            type: :object,
            properties: %{
              detail: %OpenApiSpex.Schema{type: :string, example: @invalid_token_message}
            },
            required: [:detail]
          }
        },
        required: [:errors]
      }}
    ]
  )

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
          message: @login_success_message,
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
          errors: %{detail: @invalid_token_message}
        })
    end
  end

  operation(:logout,
    summary: "Logout",
    description: "Logs out the current user",
    security: [%{"bearerAuth" => []}],
    responses: [
      ok: {"Logout successful", "application/json", %OpenApiSpex.Schema{
        type: :object,
        properties: %{
          message: %OpenApiSpex.Schema{type: :string, example: @logout_success_message}
        },
        required: [:message]
      }}
    ]
  )

  @doc """
  Log out the current user.
  """
  def logout(conn, _params) do
    conn
    |> json(%{
      message: @logout_success_message
    })
  end
end

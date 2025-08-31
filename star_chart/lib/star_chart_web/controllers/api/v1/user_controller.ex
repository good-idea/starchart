defmodule StarChartWeb.API.V1.UserController do
  use StarChartWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias StarChartWeb.Schema

  tags(["User"])

  operation(:profile,
    summary: "Get user profile",
    description: "Returns the profile information for the currently authenticated user",
    security: [%{"bearerAuth" => []}],
    responses: [
      ok:
        {"User profile", "application/json",
         %OpenApiSpex.Schema{
           type: :object,
           properties: %{
             data: %OpenApiSpex.Schema{
               type: :object,
               properties: %{
                 id: %OpenApiSpex.Schema{type: :integer, description: "User ID", example: 1},
                 email: %OpenApiSpex.Schema{
                   type: :string,
                   format: :email,
                   description: "User's email address",
                   example: "user@example.com"
                 },
                 username: %OpenApiSpex.Schema{
                   type: :string,
                   description: "User's username",
                   example: "stargazer"
                 },
                 confirmed_at: %OpenApiSpex.Schema{
                   type: :string,
                   format: :"date-time",
                   nullable: true,
                   description: "When the user confirmed their account"
                 },
                 last_login_at: %OpenApiSpex.Schema{
                   type: :string,
                   format: :"date-time",
                   nullable: true,
                   description: "When the user last logged in"
                 }
               },
               required: [:id, :email, :username]
             }
           },
           required: [:data]
         }},
      unauthorized: {"Unauthorized", "application/json", Schema.AuthenticationErrorResponse}
    ]
  )

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

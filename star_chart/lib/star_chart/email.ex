defmodule StarChart.Email do
  @moduledoc """
  Email templates for the application.
  """

  import Swoosh.Email

  @doc """
  Builds a magic link email.
  """
  def magic_link(user, token) do
    # Build the magic link URL
    url = StarChartWeb.Endpoint.url() <> "/api/auth/magic-link/#{token}"

    sender_email = Application.get_env(:star_chart, :email)[:sender_email]
    sender_name = Application.get_env(:star_chart, :email)[:sender_name]

    new()
    |> to({user.username, user.email})
    |> from({sender_name, sender_email})
    |> subject("Sign in to Star Chart")
    |> html_body("""
    <h1>Welcome to Star Chart!</h1>
    <p>Click the link below to sign in to your account:</p>
    <p><a href="#{url}">Sign in to Star Chart</a></p>
    <p>This link will expire in 24 hours.</p>
    <p>If you didn't request this email, you can safely ignore it.</p>
    """)
    |> text_body("""
    Welcome to Star Chart!

    Click the link below to sign in to your account:
    #{url}

    This link will expire in 24 hours.

    If you didn't request this email, you can safely ignore it.
    """)
  end
end

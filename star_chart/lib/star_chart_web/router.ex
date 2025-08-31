defmodule StarChartWeb.Router do
  use StarChartWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: StarChartWeb.ApiSpec
  end

  # Define a new pipeline for authenticated routes
  pipeline :auth do
    plug StarChartWeb.Plugs.AuthPlug
  end

  scope "/api" do
    pipe_through :api
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []

    scope "/v1", StarChartWeb.API.V1 do
      get "/star_systems/:origin_id/nearby", StarSystemController, :nearby

      resources "/star_systems", StarSystemController, only: [:index, :show]
      resources "/stars", StarController, only: [:show]

      # Auth routes
      post "/auth/register", AuthController, :register
      post "/auth/login", AuthController, :login
      get "/auth/verify/:token", AuthController, :verify
      post "/auth/logout", AuthController, :logout
    end
  end

  # Protected routes that require authentication
  scope "/api/v1", StarChartWeb.API.V1 do
    pipe_through [:api, :auth]

    # Add protected routes here
    get "/user/profile", UserController, :profile
  end
end

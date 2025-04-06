defmodule StarChartWeb.Router do
  use StarChartWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: MyAppWeb.ApiSpec
  end

  scope "/api" do
    pipe_through :api
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []

    scope "/v1", StarChartWeb.API.V1 do
      get "/star_systems/:origin_id/nearby", StarSystemController, :nearby

      resources "/star_systems", StarSystemController, only: [:index, :show]
      resources "/stars", StarController, only: [:show]
    end
  end
end

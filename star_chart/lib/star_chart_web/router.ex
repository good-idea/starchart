defmodule StarChartWeb.Router do
  use StarChartWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", StarChartWeb do
    pipe_through :api

    scope "/v1", API.V1 do
      get "/star_systems/:origin_id/nearby", StarSystemController, :nearby
      
      resources "/star_systems", StarSystemController, only: [:index, :show]
      resources "/stars", StarController, only: [:show]
    end
  end
end

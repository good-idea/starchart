defmodule StarChartWeb.Router do
  use StarChartWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", StarChartWeb do
    pipe_through :api
  end
end

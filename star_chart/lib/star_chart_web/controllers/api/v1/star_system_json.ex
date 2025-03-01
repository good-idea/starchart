defmodule StarChartWeb.API.V1.StarSystemJSON do
  @doc """
  Renders a list of star systems.
  """
  def index(%{star_systems: star_systems}) do
    %{data: for(star_system <- star_systems, do: data(star_system))}
  end

  @doc """
  Renders a single star system.
  """
  def show(%{star_system: star_system}) do
    %{data: data(star_system)}
  end

  defp data(%{} = star_system) do
    %{
      id: star_system.id,
      name: star_system.name,
    }
  end
end

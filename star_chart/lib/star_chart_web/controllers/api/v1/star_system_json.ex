defmodule StarChartWeb.API.V1.StarSystemJSON do
  alias StarChartWeb.API.V1.StarJSON

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
    base = %{
      id: star_system.id,
      name: star_system.name
    }

    # Add stars if they're preloaded
    if Ecto.assoc_loaded?(star_system.stars) do
      Map.put(base, :stars, for(star <- star_system.stars, do: StarJSON.data(star)))
    else
      base
    end
  end
end

defmodule StarChartWeb.API.V1.StarSystemJSON do
  alias StarChartWeb.API.V1.StarJSON

  @doc """
  Renders a list of star systems with pagination metadata.
  """
  def index(%{
        star_systems: %{
          entries: entries,
          page_number: page,
          page_size: page_size,
          total_entries: total_entries,
          total_pages: total_pages
        }
      }) do
    %{
      data: for(star_system <- entries, do: data(star_system)),
      meta: %{
        page: page,
        page_size: page_size,
        total_entries: total_entries,
        total_pages: total_pages
      }
    }
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

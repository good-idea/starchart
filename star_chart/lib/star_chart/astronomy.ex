defmodule StarChart.Astronomy do
  @moduledoc """
  The Astronomy context.
  Contains functions for managing astronomical data like star systems.
  """

  import Ecto.Query, warn: false
  alias StarChart.Repo
  alias StarChart.Astronomy.StarSystem

  @doc """
  Returns the list of star_systems.
  """
  def list_star_systems do
    Repo.all(StarSystem)
  end

  @doc """
  Gets a single star_system.
  Raises `Ecto.NoResultsError` if the Star system does not exist.
  """
  def get_star_system!(id), do: Repo.get!(StarSystem, id)

  @doc """
  Creates a star_system.
  """
  def create_star_system(attrs \\ %{}) do
    %StarSystem{}
    |> StarSystem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a star_system.
  """
  def update_star_system(%StarSystem{} = star_system, attrs) do
    star_system
    |> StarSystem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a star_system.
  """
  def delete_star_system(%StarSystem{} = star_system) do
    Repo.delete(star_system)
  end
end
defmodule StarChart.Astronomy do
  @moduledoc """
  The Astronomy context.
  Contains functions for managing astronomical data like star systems.
  """

  import Ecto.Query, warn: false
  alias StarChart.Repo
  alias StarChart.Astronomy.StarSystem

  @doc """
  Returns the list of star_systems.
  """
  def list_star_systems do
    Repo.all(StarSystem)
  end

  @doc """
  Gets a single star_system.
  Raises `Ecto.NoResultsError` if the Star system does not exist.
  """
  def get_star_system!(id), do: Repo.get!(StarSystem, id)

  @doc """
  Creates a star_system.
  """
  def create_star_system(attrs \\ %{}) do
    %StarSystem{}
    |> StarSystem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a star_system.
  """
  def update_star_system(%StarSystem{} = star_system, attrs) do
    star_system
    |> StarSystem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a star_system.
  """
  def delete_star_system(%StarSystem{} = star_system) do
    Repo.delete(star_system)
  end
end

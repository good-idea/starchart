defmodule StarChart.Astronomy do
  @moduledoc """
  The Astronomy context.
  Contains functions for managing astronomical data like star systems.
  """

  import Ecto.Query, warn: false
  alias StarChart.Repo
  alias StarChart.Astronomy.{StarSystem, Star}

  @doc """
  Returns the list of star_systems.
  """
  def list_star_systems do
    Repo.all(StarSystem)
  end

  @doc """
  Returns a paginated list of star_systems.

  ## Options

    * `:page` - The page number (default: 1)
    * `:page_size` - The number of items per page (default: 20)

  ## Examples

      iex> list_star_systems_paginated(page: 2, page_size: 10)
      %{entries: [%StarSystem{}, ...], page_number: 2, page_size: 10, total_entries: 50, total_pages: 5}

  """
  def list_star_systems_paginated(opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    page_size = Keyword.get(opts, :page_size, 100)

    query = from s in StarSystem

    # Get the total count
    total_count = Repo.aggregate(query, :count, :id)
    
    # Calculate total pages
    total_pages = ceil(total_count / page_size)
    
    # Get paginated results
    entries =
      query
      |> limit(^page_size)
      |> offset(^((page - 1) * page_size))
      |> Repo.all()

    %{
      entries: entries,
      page_number: page,
      page_size: page_size,
      total_entries: total_count,
      total_pages: total_pages
    }
  end

  @doc """
  Gets a single star_system.

  Returns `nil` if the Star System does not exist.
  """
  def get_star_system(id), do: Repo.get(StarSystem, id)

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

  @doc """
  Gets a list of stars for a specific star system.
  """
  def list_stars_by_system(star_system_id) do
    Star
    |> where(star_system_id: ^star_system_id)
    |> Repo.all()
  end

  @doc """
  Gets a single star.
  Raises `Ecto.NoResultsError` if the Star does not exist.
  """
  def get_star!(id), do: Repo.get!(Star, id) |> Star.with_virtual_fields()

  @doc """
  Creates a star.
  """
  def create_star(attrs \\ %{}) do
    %Star{}
    |> Star.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, star} -> {:ok, Star.with_virtual_fields(star)}
      error -> error
    end
  end

  @doc """
  Updates a star.
  """
  def update_star(%Star{} = star, attrs) do
    star
    |> Star.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, star} -> {:ok, Star.with_virtual_fields(star)}
      error -> error
    end
  end

  @doc """
  Deletes a star.
  """
  def delete_star(%Star{} = star) do
    Repo.delete(star)
  end
end

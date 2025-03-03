defmodule StarChart.AstronomyTest do
  use StarChart.DataCase, async: true
  import StarChart.Factory

  alias StarChart.Astronomy
  alias StarChart.Astronomy.{StarSystem, Star}

  @valid_system_attrs %{name: "Solar System"}
  @invalid_system_attrs %{name: nil}

  @valid_star_attrs %{
    name: "Earth",
    right_ascension: 14.0,
    right_ascension_degrees: 210.0,
    declination: 0.0,
    distance_parsecs: 0.0,
    proper_motion_ra: 0.0,
    proper_motion_dec: 0.0,
    radial_velocity: 0.0,
    apparent_magnitude: -3.99,
    absolute_magnitude: 4.83,
    spectral_type: "G2V",
    color_index: 0.65,
    x: 0.0,
    y: 0.0,
    z: 0.0,
    luminosity: 1.0,
    constellation: "Sol"
  }
  @invalid_star_attrs Map.drop(@valid_star_attrs, [:name, :right_ascension, :right_ascension_degrees, :declination, :distance_parsecs, :x, :y, :z])

  describe "star_systems" do
    test "list_star_systems/0 returns all star systems" do
      star_system1 = insert(:star_system, name: "Solar System")
      star_system2 = insert(:star_system, name: "Alpha Centauri")
      
      star_systems = Astronomy.list_star_systems()
      assert length(star_systems) == 2
      assert Enum.any?(star_systems, fn s -> s.id == star_system1.id end)
      assert Enum.any?(star_systems, fn s -> s.id == star_system2.id end)
    end

    test "get_star_system!/1 returns the star system with given id" do
      star_system = insert(:star_system, name: "Alpha Centauri")
      found_system = Astronomy.get_star_system!(star_system.id)
      assert found_system.id == star_system.id
      assert found_system.name == star_system.name
    end

    test "create_star_system/1 with valid data creates a star system" do
      assert {:ok, %StarSystem{} = star_system} = Astronomy.create_star_system(@valid_system_attrs)
      assert star_system.name == "Solar System"
    end

    test "create_star_system/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Astronomy.create_star_system(@invalid_system_attrs)
    end

    test "update_star_system/2 with valid data updates the star system" do
      star_system = insert(:star_system, name: "Solar System")
      update_attrs = %{name: "Updated System"}

      assert {:ok, %StarSystem{} = updated_system} = Astronomy.update_star_system(star_system, update_attrs)
      assert updated_system.name == "Updated System"
    end

    test "update_star_system/2 with invalid data returns error changeset" do
      star_system = insert(:star_system, name: "Solar System")
      assert {:error, %Ecto.Changeset{}} = Astronomy.update_star_system(star_system, @invalid_system_attrs)
      found_system = Astronomy.get_star_system!(star_system.id)
      assert found_system.name == star_system.name
    end

    test "delete_star_system/1 deletes the star system" do
      star_system = insert(:star_system, name: "Solar System")
      assert {:ok, %StarSystem{}} = Astronomy.delete_star_system(star_system)
      assert_raise Ecto.NoResultsError, fn -> Astronomy.get_star_system!(star_system.id) end
    end

    test "delete_star_system/1 deletes associated stars" do
      star_system = insert(:star_system, name: "Solar System")
      star = insert(:star, star_system_id: star_system.id)
      
      assert {:ok, %StarSystem{}} = Astronomy.delete_star_system(star_system)
      
      # This will raise an error if the star still exists
      assert_raise Ecto.NoResultsError, fn -> Astronomy.get_star!(star.id) end
    end
  end

  describe "stars" do
    setup do
      star_system = insert(:star_system, name: "Sirius System")
      %{star_system: star_system}
    end

    test "list_stars_by_system/1 returns all stars for the star system", %{star_system: star_system} do
      star1 = insert(:star, name: "Sirius A", star_system_id: star_system.id)
      star2 = insert(:star, name: "Sirius B", star_system_id: star_system.id)
      
      # Create a star in a different system to ensure filtering works
      other_system = insert(:star_system, name: "Other System")
      _other_star = insert(:star, name: "Other Star", star_system_id: other_system.id)

      stars = Astronomy.list_stars_by_system(star_system.id)
      assert length(stars) == 2
      assert Enum.any?(stars, fn s -> s.id == star1.id end)
      assert Enum.any?(stars, fn s -> s.id == star2.id end)
    end

    test "get_star!/1 returns the star with given id", %{star_system: star_system} do
      star = insert(:star, name: "Vega", star_system_id: star_system.id)
      found_star = Astronomy.get_star!(star.id)
      assert found_star.id == star.id
      assert found_star.name == star.name
    end

    test "create_star/1 with valid data creates a star", %{star_system: star_system} do
      attrs = Map.put(@valid_star_attrs, :star_system_id, star_system.id)
      assert {:ok, %Star{} = star} = Astronomy.create_star(attrs)
      assert star.name == "Earth"
      assert star.right_ascension_degrees == 210.0
      assert star.star_system_id == star_system.id
    end

    test "create_star/1 with invalid data returns error changeset", %{star_system: star_system} do
      attrs = Map.put(@invalid_star_attrs, :star_system_id, star_system.id)
      assert {:error, %Ecto.Changeset{}} = Astronomy.create_star(attrs)
    end

    test "update_star/2 with valid data updates the star", %{star_system: star_system} do
      star = insert(:star, name: "Earth", star_system_id: star_system.id)
      update_attrs = %{name: "New Earth"}

      assert {:ok, %Star{} = updated_star} = Astronomy.update_star(star, update_attrs)
      assert updated_star.name == "New Earth"
    end

    test "update_star/2 with invalid data returns error changeset", %{star_system: star_system} do
      star = insert(:star, name: "Earth", star_system_id: star_system.id)
      invalid_attrs = %{name: nil}
      assert {:error, %Ecto.Changeset{}} = Astronomy.update_star(star, Map.drop(invalid_attrs, [:star_system_id]))
      found_star = Astronomy.get_star!(star.id)
      assert found_star.name == star.name
    end

    test "delete_star/1 deletes the star", %{star_system: star_system} do
      star = insert(:star, name: "Earth", star_system_id: star_system.id)
      assert {:ok, %Star{}} = Astronomy.delete_star(star)
      assert_raise Ecto.NoResultsError, fn -> Astronomy.get_star!(star.id) end
    end
  end
end

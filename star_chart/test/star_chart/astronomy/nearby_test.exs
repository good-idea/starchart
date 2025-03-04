defmodule StarChart.Astronomy.NearbyTest do
  use StarChart.DataCase, async: true
  alias StarChart.Astronomy
  alias StarChart.Astronomy.Nearby
  alias StarChart.Astronomy.Utils.Distance
  import StarChart.Factory

  describe "find_nearby_star_systems/2" do
    setup do
      # Create an origin star system with a primary star at coordinates (0,0,0)
      origin_system = insert(:star_system, name: "Origin System")

      insert(:star, %{
        star_system_id: origin_system.id,
        name: "Origin Star",
        is_primary: true,
        x: 0.0,
        y: 0.0,
        z: 0.0
      })

      # Create nearby star systems at different distances
      # System 1: 5 parsecs / 16.3 light years away
      system1 = insert(:star_system, name: "Nearby System 1")

      insert(:star, %{
        star_system_id: system1.id,
        name: "Nearby Star 1",
        is_primary: true,
        x: 3.0,
        y: 4.0,
        z: 0.0
      })

      # System 2: 7.2 parsecs / 23.5 light years away
      system2 = insert(:star_system, name: "Nearby System 2")

      insert(:star, %{
        star_system_id: system2.id,
        name: "Nearby Star 2",
        is_primary: true,
        x: 6.0,
        y: 4.0,
        z: 0.0
      })

      # System 3: 14.4 parsecs / 47 light years away
      system3 = insert(:star_system, name: "Far System")

      insert(:star, %{
        star_system_id: system3.id,
        name: "Far Star",
        is_primary: true,
        x: 0.0,
        y: 8.0,
        z: 12.0
      })

      %{
        origin_system: origin_system,
        system1: system1,
        system2: system2,
        system3: system3
      }
    end

    test "returns nearby star systems within default distance", %{
      origin_system: origin_system,
      system1: system1,
      system2: system2
    } do
      # Default distance is 25 light years (about 7.67 parsecs)
      results = Nearby.find_nearby_star_systems(origin_system.id)

      # Should return both system1 (5 parsecs) and system2 (10 parsecs)
      assert length(results) == 2

      # Extract system IDs from results
      system_ids = Enum.map(results, fn %{system: system} -> system.id end)

      # Check that both nearby systems are included
      assert system1.id in system_ids
      assert system2.id in system_ids

      # Check that results are sorted by distance (closest first)
      [first, second] = results
      assert first.system.id == system1.id
      assert second.system.id == system2.id
    end

    test "returns nearby star systems within custom distance", %{
      origin_system: origin_system,
      system1: system1
    } do
      # Set distance to 6 light years (about 1.84 parsecs)
      # This should only include system1 (5 parsecs)
      results = Nearby.find_nearby_star_systems(origin_system.id, max_distance: 20.0)

      # Should return only system1
      assert length(results) == 1

      # Check that only the closest system is included
      [result] = results
      assert result.system.id == system1.id
    end

    test "returns empty list when no systems are within distance", %{origin_system: origin_system} do
      # Set distance to 1 light year (about 0.31 parsecs)
      # This should not include any systems
      results = Nearby.find_nearby_star_systems(origin_system.id, max_distance: 1.0)

      # Should return empty list
      assert results == []
    end

    test "returns error when origin system does not exist" do
      # Try to find nearby systems for a non-existent origin
      result = Nearby.find_nearby_star_systems(999)

      # Should return error
      assert result == {:error, :not_found}
    end

    test "includes distance information in results", %{origin_system: origin_system} do
      [result | _] = Nearby.find_nearby_star_systems(origin_system.id)

      # Check that distance information is included
      assert %{system: _, distance: %Distance{}} = result
      assert result.distance.distance_parsecs > 0
      assert result.distance.distance_light_years > 0
    end
  end
end

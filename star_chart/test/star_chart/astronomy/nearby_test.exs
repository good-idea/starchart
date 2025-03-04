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
      assert length(results.entries) == 2

      # Extract system IDs from results
      system_ids = Enum.map(results.entries, fn %{system: system} -> system.id end)

      # Check that both nearby systems are included
      assert system1.id in system_ids
      assert system2.id in system_ids

      # Check that results are sorted by distance (closest first)
      [first, second] = results.entries
      assert first.system.id == system1.id
      assert second.system.id == system2.id

      # Check pagination metadata
      assert results.page_number == 1
      assert results.page_size == 100
      assert results.total_entries == 2
      assert results.total_pages == 1
    end

    test "returns nearby star systems within custom distance", %{
      origin_system: origin_system,
      system1: system1
    } do
      # Set distance to 20 light years
      # This should only include system1
      results = Nearby.find_nearby_star_systems(origin_system.id, max_distance: 20.0)

      # Should return only system1
      assert length(results.entries) == 1

      # Check that only the closest system is included
      [result] = results.entries
      assert result.system.id == system1.id

      # Check pagination metadata
      assert results.page_number == 1
      assert results.page_size == 100
      assert results.total_entries == 1
      assert results.total_pages == 1
    end

    test "returns empty list when no systems are within distance", %{origin_system: origin_system} do
      # Set distance to 1 light year (about 0.31 parsecs)
      # This should not include any systems
      results = Nearby.find_nearby_star_systems(origin_system.id, max_distance: 1.0)

      # Should return empty entries list
      assert results.entries == []

      # Check pagination metadata
      assert results.page_number == 1
      assert results.page_size == 100
      assert results.total_entries == 0
      assert results.total_pages == 0
    end

    test "returns error when origin system does not exist" do
      # Try to find nearby systems for a non-existent origin
      result = Nearby.find_nearby_star_systems(999)

      # Should return error
      assert result == {:error, :not_found}
    end

    test "includes distance information in results", %{origin_system: origin_system} do
      %{entries: [result | _]} = Nearby.find_nearby_star_systems(origin_system.id)

      # Check that distance information is included
      assert %{system: _, distance: %Distance{}} = result
      assert result.distance.distance_parsecs > 0
      assert result.distance.distance_light_years > 0
    end
  end

  describe "find_nearby_star_systems/2 with pagination" do
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

      # Create 15 nearby star systems at different distances
      # Make sure all are within the default 25 light years (about 7.67 parsecs)
      # We'll use a distance of i*0.5 parsecs to ensure they're all close enough
      systems =
        Enum.map(1..15, fn i ->
          system = insert(:star_system, name: "System #{i}")

          # Create a primary star with coordinates that put it at distance i*0.5 parsecs
          insert(:star, %{
            star_system_id: system.id,
            name: "Star #{i}",
            is_primary: true,
            x: i * 0.5,
            y: 0.0,
            z: 0.0
          })

          system
        end)

      %{
        origin_system: origin_system,
        systems: systems
      }
    end

    test "paginates results correctly", %{origin_system: origin_system} do
      # Get first page with 5 items per page
      page1 = Nearby.find_nearby_star_systems(origin_system.id, page: 1, page_size: 5)

      # Check pagination metadata
      assert page1.page_number == 1
      assert page1.page_size == 5
      assert page1.total_entries == 15
      assert page1.total_pages == 3

      # Check that we got the first 5 systems (closest first)
      assert length(page1.entries) == 5

      first_page_distances =
        Enum.map(page1.entries, fn %{distance: distance} ->
          distance.distance_parsecs
        end)

      assert first_page_distances == [0.5, 1.0, 1.5, 2.0, 2.5]

      # Get second page
      page2 = Nearby.find_nearby_star_systems(origin_system.id, page: 2, page_size: 5)

      # Check pagination metadata
      assert page2.page_number == 2
      assert page2.page_size == 5
      assert page2.total_entries == 15
      assert page2.total_pages == 3

      # Check that we got the next 5 systems
      assert length(page2.entries) == 5

      second_page_distances =
        Enum.map(page2.entries, fn %{distance: distance} ->
          distance.distance_parsecs
        end)

      assert second_page_distances == [3.0, 3.5, 4.0, 4.5, 5.0]
    end

    test "handles page beyond available data", %{origin_system: origin_system} do
      # Request a page that's beyond the available data
      results = Nearby.find_nearby_star_systems(origin_system.id, page: 10, page_size: 5)

      # Should return empty entries but correct metadata
      assert results.entries == []
      assert results.page_number == 10
      # Fix this to match the requested page_size
      assert results.page_size == 5
      assert results.total_entries == 15
      # Fix this to match the actual number of pages
      assert results.total_pages == 3
    end
  end

  describe "find_nearby_star_systems/2 with spectral class and star count filters" do
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

      # Create star systems with different spectral classes and star counts
      # All within the default 25 light years (about 7.67 parsecs)

      # System 1: G-class with 1 star at distance 1 parsec
      system1 = insert(:star_system, name: "G System Single")

      insert(:star, %{
        star_system_id: system1.id,
        name: "G Star",
        is_primary: true,
        spectral_class: "G",
        spectral_type: "G2V",
        x: 1.0,
        y: 0.0,
        z: 0.0
      })

      # System 2: G-class with 2 stars at distance 2 parsecs
      system2 = insert(:star_system, name: "G System Binary")

      insert(:star, %{
        star_system_id: system2.id,
        name: "G Primary",
        is_primary: true,
        spectral_class: "G",
        spectral_type: "G5V",
        x: 2.0,
        y: 0.0,
        z: 0.0
      })

      insert(:star, %{
        star_system_id: system2.id,
        name: "G Secondary",
        is_primary: false,
        spectral_class: "K",
        spectral_type: "K2V",
        x: 2.0,
        y: 0.0,
        z: 0.0
      })

      # System 3: K-class with 3 stars at distance 3 parsecs
      system3 = insert(:star_system, name: "K System Triple")

      insert(:star, %{
        star_system_id: system3.id,
        name: "K Primary",
        is_primary: true,
        spectral_class: "K",
        spectral_type: "K0V",
        x: 3.0,
        y: 0.0,
        z: 0.0
      })

      insert(:star, %{
        star_system_id: system3.id,
        name: "K Secondary 1",
        is_primary: false,
        spectral_class: "K",
        spectral_type: "K5V",
        x: 3.0,
        y: 0.0,
        z: 0.0
      })

      insert(:star, %{
        star_system_id: system3.id,
        name: "K Secondary 2",
        is_primary: false,
        spectral_class: "M",
        spectral_type: "M2V",
        x: 3.0,
        y: 0.0,
        z: 0.0
      })

      %{
        origin_system: origin_system,
        g_system_single: system1,
        g_system_binary: system2,
        k_system_triple: system3
      }
    end

    test "filters by spectral class", %{
      origin_system: origin_system,
      g_system_single: g_system_single,
      g_system_binary: g_system_binary
    } do
      # Filter for G-class stars only
      results = Nearby.find_nearby_star_systems(origin_system.id, spectral_class: "G")

      # Should return both G-class systems
      assert length(results.entries) == 2

      # Extract system IDs from results
      system_ids = Enum.map(results.entries, fn %{system: system} -> system.id end)

      # Check that both G-class systems are included
      assert g_system_single.id in system_ids
      assert g_system_binary.id in system_ids
    end

    test "filters by minimum star count", %{
      origin_system: origin_system,
      g_system_binary: g_system_binary,
      k_system_triple: k_system_triple
    } do
      # Filter for systems with at least 2 stars
      results = Nearby.find_nearby_star_systems(origin_system.id, min_stars: 2)

      # Should return the binary and triple systems
      assert length(results.entries) == 2

      # Extract system IDs from results
      system_ids = Enum.map(results.entries, fn %{system: system} -> system.id end)

      # Check that both multi-star systems are included
      assert g_system_binary.id in system_ids
      assert k_system_triple.id in system_ids
    end

    test "filters by maximum star count", %{
      origin_system: origin_system,
      g_system_single: g_system_single,
      g_system_binary: g_system_binary
    } do
      # Filter for systems with at most 2 stars
      results = Nearby.find_nearby_star_systems(origin_system.id, max_stars: 2)

      # Should return the single and binary systems
      assert length(results.entries) == 2

      # Extract system IDs from results
      system_ids = Enum.map(results.entries, fn %{system: system} -> system.id end)

      # Check that both systems with ≤ 2 stars are included
      assert g_system_single.id in system_ids
      assert g_system_binary.id in system_ids
    end

    test "combines spectral class and star count filters", %{
      origin_system: origin_system,
      g_system_binary: g_system_binary
    } do
      # Filter for G-class systems with at least 2 stars
      results =
        Nearby.find_nearby_star_systems(origin_system.id,
          spectral_class: "G",
          min_stars: 2
        )

      # Should return only the G-class binary system
      assert length(results.entries) == 1

      # Check that only the G-class binary system is included
      [result] = results.entries
      assert result.system.id == g_system_binary.id
    end

    test "returns empty list when no systems match filters", %{origin_system: origin_system} do
      # Filter for M-class systems with at least 3 stars (none exist in our test data)
      results =
        Nearby.find_nearby_star_systems(origin_system.id,
          spectral_class: "M",
          min_stars: 3
        )

      # Should return empty entries list
      assert results.entries == []

      # Check pagination metadata
      assert results.page_number == 1
      assert results.page_size == 100
      assert results.total_entries == 0
      assert results.total_pages == 0
    end
  end
end

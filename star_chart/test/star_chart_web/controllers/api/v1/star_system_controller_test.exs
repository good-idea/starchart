defmodule StarChartWeb.API.V1.StarSystemControllerTest do
  use StarChartWeb.ConnCase, async: true
  import StarChart.Factory

  describe "GET /api/v1/star_systems" do
    test "returns a list of star systems with pagination", %{conn: conn} do
      system1 = insert(:star_system, name: "Solar System")
      system2 = insert(:star_system, name: "Alpha Centauri")

      # Add primary stars to each system
      insert(:star, star_system: system1, name: "Sun", is_primary: true)
      insert(:star, star_system: system2, name: "Alpha Centauri A", is_primary: true)

      conn = get(conn, ~p"/api/v1/star_systems")
      response = json_response(conn, 200)

      assert %{"data" => data, "meta" => meta} = response
      assert length(data) == 2
      assert Enum.any?(data, fn d -> d["name"] == "Solar System" end)
      assert Enum.any?(data, fn d -> d["name"] == "Alpha Centauri" end)

      # Check pagination metadata
      assert meta["page"] == 1
      assert meta["page_size"] == 100
      assert meta["total_entries"] == 2
      assert meta["total_pages"] == 1
    end

    test "returns a list of star systems with primary star data and star count", %{conn: conn} do
      system1 = insert(:star_system, name: "Solar System")
      system2 = insert(:star_system, name: "Alpha Centauri")

      # Add primary stars
      insert(:star,
        star_system: system1,
        name: "Sun",
        proper_name: "Sol",
        is_primary: true
      )

      insert(:star,
        star_system: system2,
        name: "Alpha Centauri A",
        proper_name: "Rigil Kentaurus",
        is_primary: true
      )

      # Add secondary stars to Alpha Centauri
      insert(:star,
        star_system: system2,
        name: "Alpha Centauri B",
        is_primary: false
      )

      insert(:star,
        star_system: system2,
        name: "Proxima Centauri",
        is_primary: false
      )

      conn = get(conn, ~p"/api/v1/star_systems")
      response = json_response(conn, 200)

      assert %{"data" => data} = response
      assert length(data) == 2

      # Check that both systems have primary star data and star count
      solar_system = Enum.find(data, fn d -> d["name"] == "Solar System" end)
      alpha_centauri = Enum.find(data, fn d -> d["name"] == "Alpha Centauri" end)

      assert solar_system["primary_star"]["name"] == "Sun"
      assert solar_system["primary_star"]["proper_name"] == "Sol"
      assert solar_system["star_count"] == 1

      assert alpha_centauri["primary_star"]["name"] == "Alpha Centauri A"
      assert alpha_centauri["primary_star"]["proper_name"] == "Rigil Kentaurus"
      assert alpha_centauri["star_count"] == 3
    end

    test "returns an empty list when no star systems exist", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/star_systems")
      response = json_response(conn, 200)
      assert response["data"] == []
      assert response["meta"]["total_entries"] == 0
    end

    test "paginates results correctly", %{conn: conn} do
      # Create 25 star systems with primary stars
      for i <- 1..25 do
        system = insert(:star_system, name: "Star System #{i}")
        insert(:star, star_system: system, name: "Primary Star #{i}", is_primary: true)
      end

      # Request page 2 with 10 items per page
      conn = get(conn, ~p"/api/v1/star_systems?page=2&page_size=10")
      response = json_response(conn, 200)

      assert %{"data" => data, "meta" => meta} = response
      assert length(data) == 10
      assert meta["page"] == 2
      assert meta["page_size"] == 10
      assert meta["total_entries"] == 25
      assert meta["total_pages"] == 3
    end

    test "returns error when page_size exceeds maximum", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/star_systems?page_size=201")
      response = json_response(conn, 400)

      assert %{"errors" => %{"detail" => message}} = response
      assert String.contains?(message, "Invalid parameter 'page_size'")
      assert String.contains?(message, "must be less than or equal to 200")
    end

    test "returns error when page is less than minimum", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/star_systems?page=0")
      response = json_response(conn, 400)

      assert %{"errors" => %{"detail" => message}} = response
      assert String.contains?(message, "Invalid parameter 'page'")
      assert String.contains?(message, "must be greater than or equal to 1")
    end
  end

  describe "GET /api/v1/star_systems/:id" do
    test "returns the specified star system with primary star data", %{conn: conn} do
      star_system = insert(:star_system, name: "Alpha Centauri")

      primary_star =
        insert(:star,
          star_system: star_system,
          name: "Alpha Centauri A",
          proper_name: "Rigil Kentaurus",
          is_primary: true,
          distance_parsecs: 4.37,
          apparent_magnitude: -0.27,
          absolute_magnitude: 4.38,
          spectral_type: "G2V",
          spectral_class: "G"
        )

      conn = get(conn, ~p"/api/v1/star_systems/#{star_system.id}")
      star_system_id = star_system.id
      primary_star_id = primary_star.id

      assert %{
               "data" => %{
                 "id" => ^star_system_id,
                 "name" => "Alpha Centauri",
                 "primary_star" => %{
                   "id" => ^primary_star_id,
                   "name" => "Alpha Centauri A",
                   "proper_name" => "Rigil Kentaurus",
                   "distance_parsecs" => distance,
                   "apparent_magnitude" => -0.27,
                   "absolute_magnitude" => 4.38,
                   "spectral_type" => "G2V"
                 }
               }
             } = json_response(conn, 200)
    end

    test "returns the specified star system with primary and secondary stars", %{conn: conn} do
      star_system = insert(:star_system, name: "Alpha Centauri")

      primary_star =
        insert(:star,
          star_system: star_system,
          name: "Alpha Centauri A",
          proper_name: "Rigil Kentaurus",
          is_primary: true,
          distance_parsecs: 4.37,
          apparent_magnitude: -0.27,
          absolute_magnitude: 4.38,
          spectral_type: "G2V",
          spectral_class: "G"
        )

      secondary_star1 =
        insert(:star,
          star_system: star_system,
          name: "Alpha Centauri B",
          proper_name: nil,
          is_primary: false,
          distance_parsecs: 4.37,
          apparent_magnitude: 1.33,
          absolute_magnitude: 5.71,
          spectral_type: "K1V",
          spectral_class: "K"
        )

      secondary_star2 =
        insert(:star,
          star_system: star_system,
          name: "Proxima Centauri",
          proper_name: nil,
          is_primary: false,
          distance_parsecs: 4.24,
          apparent_magnitude: 11.05,
          absolute_magnitude: 15.60,
          spectral_type: "M5.5Ve",
          spectral_class: "M"
        )

      conn = get(conn, ~p"/api/v1/star_systems/#{star_system.id}")
      response = json_response(conn, 200)

      star_system_id = star_system.id
      primary_star_id = primary_star.id
      secondary_star1_id = secondary_star1.id
      secondary_star2_id = secondary_star2.id

      assert %{
               "data" => %{
                 "id" => ^star_system_id,
                 "name" => "Alpha Centauri",
                 "star_count" => 3,
                 "primary_star" => %{
                   "id" => ^primary_star_id,
                   "name" => "Alpha Centauri A",
                   "proper_name" => "Rigil Kentaurus",
                   "spectral_type" => "G2V",
                   "spectral_class" => "G"
                   # other fields omitted for brevity
                 },
                 "secondary_stars" => secondary_stars
               }
             } = response

      # Verify secondary stars are included
      assert length(secondary_stars) == 2

      # Find each secondary star in the response
      found_star1 = Enum.find(secondary_stars, fn star -> star["id"] == secondary_star1_id end)
      found_star2 = Enum.find(secondary_stars, fn star -> star["id"] == secondary_star2_id end)

      # Verify first secondary star
      assert found_star1["name"] == "Alpha Centauri B"
      assert found_star1["spectral_type"] == "K1V"
      assert found_star1["spectral_class"] == "K"

      # Verify second secondary star
      assert found_star2["name"] == "Proxima Centauri"
      assert found_star2["spectral_type"] == "M5.5Ve"
      assert found_star2["spectral_class"] == "M"
    end

    test "returns 404 when star system is not found", %{conn: conn} do
      assert_error_sent(404, fn ->
        get(conn, ~p"/api/v1/star_systems/999999")
      end)
    end
  end

  describe "filtering star systems" do
    test "filters star systems by spectral class", %{conn: conn} do
      # Create a star system with G-type primary star (Sun-like)
      system1 = insert(:star_system, name: "Solar System")

      insert(:star,
        star_system: system1,
        name: "Sun",
        is_primary: true,
        spectral_type: "G2V",
        spectral_class: "G"
      )

      # Create a star system with K-type primary star
      system2 = insert(:star_system, name: "Alpha Centauri")

      insert(:star,
        star_system: system2,
        name: "Alpha Centauri A",
        is_primary: true,
        spectral_type: "K1V",
        spectral_class: "K"
      )

      # Create a binary system with M-type primary and G-type secondary
      system3 = insert(:star_system, name: "Binary System")

      insert(:star,
        star_system: system3,
        name: "Primary Star",
        is_primary: true,
        spectral_type: "M5V",
        spectral_class: "M"
      )

      insert(:star,
        star_system: system3,
        name: "Secondary Star",
        is_primary: false,
        spectral_type: "G8V",
        spectral_class: "G"
      )

      # Request with spectral_class=G filter
      conn = get(conn, ~p"/api/v1/star_systems?spectral_class=G")
      response = json_response(conn, 200)

      # Verify we only get star systems with G-type stars (system1 and system3)
      assert length(response["data"]) == 2

      # Check that the returned systems are the ones with G-type stars
      system_names = Enum.map(response["data"], fn system -> system["name"] end)
      assert "Solar System" in system_names
      assert "Binary System" in system_names
      refute "Alpha Centauri" in system_names
    end

    test "returns empty list when no star systems match spectral class", %{conn: conn} do
      # Create a star system with G-type primary star
      system = insert(:star_system, name: "Solar System")

      insert(:star,
        star_system: system,
        name: "Sun",
        is_primary: true,
        spectral_type: "G2V"
      )

      # Request with a spectral class that doesn't exist in our test data
      conn = get(conn, ~p"/api/v1/star_systems?spectral_class=Y")
      response = json_response(conn, 200)

      # Verify we get an empty list but proper structure
      assert response["data"] == []
      assert response["meta"]["total_entries"] == 0
      assert response["meta"]["total_pages"] == 0
    end

    test "returns 400 for invalid spectral class", %{conn: conn} do
      # Request with invalid spectral class
      conn = get(conn, ~p"/api/v1/star_systems?spectral_class=X")
      response = json_response(conn, 400)

      # Verify we get a proper error message
      assert %{"errors" => %{"detail" => message}} = response
      assert String.contains?(message, "Invalid parameter 'spectral_class'")
    end
  end
end

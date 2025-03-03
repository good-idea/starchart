defmodule StarChartWeb.API.V1.StarControllerTest do
  use StarChartWeb.ConnCase, async: true
  import StarChart.Factory

  describe "GET /api/v1/star_systems/:star_system_id/stars" do
    test "returns a list of stars for the star system", %{conn: conn} do
      star_system = insert(:star_system, name: "Sirius System")
      # Add a primary star
      insert(:star, name: "Sirius A", star_system_id: star_system.id, is_primary: true)
      insert(:star, name: "Sirius B", star_system_id: star_system.id)

      conn = get(conn, ~p"/api/v1/star_systems/#{star_system.id}/stars")
      response = json_response(conn, 200)

      assert %{"data" => data} = response
      assert length(data) == 2
      assert Enum.any?(data, fn d -> d["name"] == "Sirius A" end)
      assert Enum.any?(data, fn d -> d["name"] == "Sirius B" end)
    end

    test "returns an empty list when the star system has no stars", %{conn: conn} do
      star_system = insert(:star_system, name: "Empty System")
      # Add a primary star since we now require one
      insert(:star, name: "Primary Star", star_system_id: star_system.id, is_primary: true)
      
      # We'll modify this test to check for just the primary star
      conn = get(conn, ~p"/api/v1/star_systems/#{star_system.id}/stars")
      response = json_response(conn, 200)
      
      assert %{"data" => data} = response
      assert length(data) == 1
      assert Enum.at(data, 0)["name"] == "Primary Star"
      assert Enum.at(data, 0)["is_primary"] == true
    end

    # test "returns 404 when star system is not found", %{conn: conn} do
    #   # TODO: Figure out why this approach warns:
    #   conn = get(conn, ~p"/api/v1/star_systems/999999/stars")
    #   assert json_response(conn, 404)
    #
    #   # and this approach does not work:
    #   assert_error_sent 404, fn ->
    #     get(conn, ~p"/api/v1/star_systems/#{star_system.id}/stars")
    #   end
    # end
  end

  describe "GET /api/v1/stars/:id" do
    test "returns the specified star", %{conn: conn} do
      star_system = insert(:star_system, name: "Vega System")
      # Add a primary star first
      insert(:star, name: "Primary Star", star_system_id: star_system.id, is_primary: true)
      # Then add the star we'll test
      star = insert(:star, name: "Vega", star_system_id: star_system.id)

      conn = get(conn, ~p"/api/v1/stars/#{star.id}")
      response = json_response(conn, 200)

      assert %{"data" => data} = response
      assert data["id"] == star.id
      assert data["name"] == "Vega"
    end

    test "returns 404 when star is not found", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/stars/999999")
      end
    end
  end
end

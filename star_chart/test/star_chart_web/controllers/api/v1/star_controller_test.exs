defmodule StarChartWeb.API.V1.StarControllerTest do
  use StarChartWeb.ConnCase, async: true
  import StarChart.Factory

  alias StarChart.Astronomy
  alias StarChart.Astronomy.{StarSystem, Star}

  describe "GET /api/v1/star_systems/:star_system_id/stars" do
    test "returns a list of stars for the star system", %{conn: conn} do
      star_system = insert(:star_system, name: "Sirius System")
      star1 = insert(:star, name: "Sirius A", star_system_id: star_system.id)
      star2 = insert(:star, name: "Sirius B", star_system_id: star_system.id)

      conn = get(conn, ~p"/api/v1/star_systems/#{star_system.id}/stars")
      response = json_response(conn, 200)
      
      assert %{"data" => data} = response
      assert length(data) == 2
      assert Enum.any?(data, fn d -> d["name"] == "Sirius A" end)
      assert Enum.any?(data, fn d -> d["name"] == "Sirius B" end)
    end

    test "returns an empty list when the star system has no stars", %{conn: conn} do
      star_system = insert(:star_system, name: "Empty System")
      conn = get(conn, ~p"/api/v1/star_systems/#{star_system.id}/stars")
      assert json_response(conn, 200)["data"] == []
    end

    test "returns 404 when star system is not found", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/star_systems/999999/stars")
      end
    end
  end

  describe "GET /api/v1/stars/:id" do
    test "returns the specified star", %{conn: conn} do
      star_system = insert(:star_system, name: "Vega System")
      star = insert(:star, name: "Vega", star_system_id: star_system.id)

      conn = get(conn, ~p"/api/v1/stars/#{star.id}")
      response = json_response(conn, 200)
      
      assert %{"data" => data} = response
      assert data["id"] == star.id
      assert data["name"] == "Vega"
      assert data["star_system_id"] == star_system.id
    end

    test "returns 404 when star is not found", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/stars/999999")
      end
    end
  end
end

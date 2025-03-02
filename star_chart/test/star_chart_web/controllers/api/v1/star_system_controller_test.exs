defmodule StarChartWeb.API.V1.StarSystemControllerTest do
  use StarChartWeb.ConnCase, async: true
  import StarChart.Factory

  alias StarChart.Astronomy
  alias StarChart.Astronomy.StarSystem

  describe "GET /api/v1/star_systems" do
    test "returns a list of star systems", %{conn: conn} do
      star_system1 = insert(:star_system, name: "Solar System")
      star_system2 = insert(:star_system, name: "Alpha Centauri")

      conn = get(conn, ~p"/api/v1/star_systems")
      response = json_response(conn, 200)
      
      assert %{"data" => data} = response
      assert length(data) == 2
      assert Enum.any?(data, fn d -> d["name"] == "Solar System" end)
      assert Enum.any?(data, fn d -> d["name"] == "Alpha Centauri" end)
    end

    test "returns an empty list when no star systems exist", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/star_systems")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "GET /api/v1/star_systems/:id" do
    test "returns the specified star system", %{conn: conn} do
      star_system = insert(:star_system, name: "Alpha Centauri")
      conn = get(conn, ~p"/api/v1/star_systems/#{star_system.id}")
      
      assert %{
               "data" => %{
                 "id" => star_system.id,
                 "name" => "Alpha Centauri"
               }
             } = json_response(conn, 200)
    end

    test "returns 404 when star system is not found", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/star_systems/999999")
      end
    end
  end
end

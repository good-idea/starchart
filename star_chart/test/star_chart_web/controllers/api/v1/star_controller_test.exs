defmodule StarChartWeb.API.V1.StarControllerTest do
  use StarChartWeb.ConnCase, async: true
  import StarChart.Factory

  describe "GET /api/v1/stars/:id" do
    test "returns the specified star with all fields", %{conn: conn} do
      star_system = insert(:star_system, name: "Vega System")
      # Add a primary star first
      insert(:star, name: "Primary Star", star_system_id: star_system.id, is_primary: true)
      # Then add the star we'll test
      star = insert(:star, 
        name: "Vega", 
        star_system_id: star_system.id,
        spectral_type: "A0Va",
        spectral_class: "A"
      )

      conn = get(conn, ~p"/api/v1/stars/#{star.id}")
      response = json_response(conn, 200)

      assert %{"data" => data} = response
      assert data["id"] == star.id
      assert data["name"] == "Vega"
      assert data["spectral_type"] == "A0Va"
      assert data["spectral_class"] == "A"
    end

    test "returns 404 when star is not found", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/stars/999999")
      end
    end
  end
end

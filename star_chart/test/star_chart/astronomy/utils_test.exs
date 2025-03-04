defmodule StarChart.Astronomy.UtilsTest do
  use StarChart.DataCase, async: true
  alias StarChart.Astronomy.Utils
  alias StarChart.Astronomy.Utils.Distance

  @parsec_to_ly StarChart.Astronomy.Constants.parsec_to_ly()

  describe "parsec_to_light_years/1" do
    test "converts 1 parsec to 3.26 light years" do
      assert_in_delta Utils.parsec_to_light_years(1), @parsec_to_ly, 1.0
    end

    test "converts 0 parsecs to 0 light years" do
      assert_in_delta Utils.parsec_to_light_years(0), 0.0, 1.0
    end

    test "converts negative parsec values to negative light years" do
      assert_in_delta Utils.parsec_to_light_years(-2.5), -2.5 * @parsec_to_ly, 1.0
    end

    test "converts floating-point parsec values accurately" do
      assert_in_delta Utils.parsec_to_light_years(3.0), 3.0 * @parsec_to_ly, 1.0
    end

    test "handles extremely large parsec values" do
      large_parsec = 1.0e12
      assert_in_delta Utils.parsec_to_light_years(large_parsec), @parsec_to_ly * large_parsec, 1.0
    end
  end

  describe "light_years_to_parsec/1" do
    test "converts 3.26... light years to 1 parsec" do
      assert_in_delta Utils.light_years_to_parsec(@parsec_to_ly), 1.0, 1.0
    end

    test "converts 0 light years to 0 parsecs" do
      assert_in_delta Utils.light_years_to_parsec(0), 0.0, 1.0
    end

    test "converts negative light years values to negative parsecs" do
      assert_in_delta Utils.light_years_to_parsec(-2.5 * @parsec_to_ly), -2.5, 1.0
    end

    test "converts floating-point light years values accurately" do
      assert_in_delta Utils.light_years_to_parsec(9.79), 9.79 / @parsec_to_ly, 1.0
    end

    test "handles extremely large light years values" do
      large_light_years = 1.0e12

      assert_in_delta Utils.light_years_to_parsec(large_light_years),
                      large_light_years / @parsec_to_ly,
                      1.0
    end
  end

  describe "calculate_distance_between_systems/2" do
    test "calculates correct distance between two star systems" do
      # Create two star systems with primary stars that have coordinates
      system1 = %{
        primary_star: %{
          x: 0.0,
          y: 0.0,
          z: 0.0
        }
      }
      
      system2 = %{
        primary_star: %{
          x: 3.0,
          y: 4.0,
          z: 0.0
        }
      }
      
      result = Utils.calculate_distance_between_systems(system1, system2)
      
      # The distance should be 5.0 parsecs (3-4-5 triangle)
      assert result.distance_parsecs == 5.0
      
      # The light year distance should be the parsec distance converted
      expected_ly = Utils.parsec_to_light_years(5.0)
      assert result.distance_light_years == expected_ly
    end
    
    test "calculates distance with different coordinates" do
      system1 = %{
        primary_star: %{
          x: 1.0,
          y: 2.0,
          z: 3.0
        }
      }
      
      system2 = %{
        primary_star: %{
          x: 4.0,
          y: 5.0,
          z: 6.0
        }
      }
      
      result = Utils.calculate_distance_between_systems(system1, system2)
      
      # Distance should be sqrt((4-1)^2 + (5-2)^2 + (6-3)^2) = sqrt(27) = 5.196
      expected_parsecs = :math.sqrt(27)
      assert_in_delta result.distance_parsecs, expected_parsecs, 0.001
      
      # Light year distance should match the conversion
      expected_ly = Utils.parsec_to_light_years(expected_parsecs)
      assert result.distance_light_years == expected_ly
    end
  end
end

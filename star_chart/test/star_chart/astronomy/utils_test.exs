defmodule StarChart.Astronomy.UtilsTest do
  use StarChart.DataCase, async: true
  alias StarChart.Astronomy.Utils

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
end

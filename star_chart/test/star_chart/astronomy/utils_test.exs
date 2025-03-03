defmodule StarChart.Astronomy.UtilsTest do
  use ExUnit.Case, async: true

  alias StarChart.Astronomy.Utils

  describe "parsec_to_light_years/1" do
    test "converts 1 parsec to 3.26 light years" do
      assert Utils.parsec_to_light_years(1) == 3.26
    end

    test "converts 0 parsec to 0 light years" do
      assert Utils.parsec_to_light_years(0) == 0.0
    end

    test "converts negative parsec values to negative light years" do
      assert Utils.parsec_to_light_years(-2.5) == -8.15
    end

    test "converts floating-point parsec values accurately" do
      assert_in_delta Utils.parsec_to_light_years(1.5), 4.89, 0.0001
    end

    test "raises FunctionClauseError when given a non-numeric input" do
      assert_raise FunctionClauseError, fn ->
        Utils.parsec_to_light_years("one parsec")
      end
    end

    test "handles extremely large parsec values" do
      large_parsec = 1.0e12
      assert Utils.parsec_to_light_years(large_parsec) == 3.26 * large_parsec
    end
  end

  describe "light_years_to_parsec/1" do
    test "converts 3.26 light years to 1 parsec" do
      assert_in_delta Utils.light_years_to_parsec(3.26), 1.0, 0.0001
    end

    test "converts 0 light years to 0 parsecs" do
      assert Utils.light_years_to_parsec(0) == 0.0
    end

    test "converts negative light years values to negative parsecs" do
      assert_in_delta Utils.light_years_to_parsec(-6.53), -2.0, 0.0001
    end

    test "converts floating-point light years values accurately" do
      assert_in_delta Utils.light_years_to_parsec(9.79), 3.0, 0.0001
    end

    test "raises FunctionClauseError when given a non-numeric input" do
      assert_raise FunctionClauseError, fn ->
        Utils.light_years_to_parsec("three point two six")
      end
    end

    test "handles extremely large light years values" do
      large_light_years = 1.0e12
      assert Utils.light_years_to_parsec(large_light_years) == 0.3066 * large_light_years
    end
  end
end

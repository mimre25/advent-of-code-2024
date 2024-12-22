defmodule TwentyTwoTest do
  use ExUnit.Case
  alias AdventOfCode.TwentyTwo

  test "part_one" do
    assert TwentyTwo.part_one(
             TestUtils.Input.str_to_list("""
             1
             10
             100
             2024
             """)
           ) == 37_327_623
  end

  test "pnr" do
    assert TwentyTwo.pnr(1, 2000) |> Enum.at(-1) == 8_685_429
    assert TwentyTwo.pnr(10, 2000) |> Enum.at(-1) == 4_700_978
    assert TwentyTwo.pnr(100, 2000) |> Enum.at(-1) == 15_273_692
    assert TwentyTwo.pnr(2024, 2000) |> Enum.at(-1) == 8_667_524

    assert TwentyTwo.pnr(123, 10) == [
             123,
             15_887_950,
             16_495_136,
             527_345,
             704_524,
             1_553_684,
             12_683_156,
             11_100_544,
             12_249_484,
             7_753_432,
             5_908_254
           ]
  end

  test "part_two" do
    assert TwentyTwo.part_two(
             TestUtils.Input.str_to_list("""
             1
             2
             3
             2024
             """)
           ) == 23
  end
end

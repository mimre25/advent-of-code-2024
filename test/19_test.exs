defmodule NineteenTest do
  use ExUnit.Case
  alias AdventOfCode.Nineteen

  test "part_one" do
    assert Nineteen.part_one(
             TestUtils.Input.str_to_list("""
             r, wr, b, g, bwu, rb, gb, br

             brwrr
             bggr
             gbbr
             rrbgbr
             ubwu
             bwurrg
             brgr
             bbrgwb
             """)
           ) == 6
  end

  test "part_two" do
    assert Nineteen.part_two(
             TestUtils.Input.str_to_list("""
             r, wr, b, g, bwu, rb, gb, br

             brwrr
             bggr
             gbbr
             rrbgbr
             ubwu
             bwurrg
             brgr
             bbrgwb
             """)
           ) == 16
  end
end

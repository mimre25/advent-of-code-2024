defmodule TwelveTest do
  use ExUnit.Case
  alias AdventOfCode.Twelve

  test "part_one" do
    assert Twelve.part_one(
             TestUtils.Input.str_to_matrix("""
             AAAA
             BBCD
             BBCC
             EEEC
             """)
           ) == 140

    assert Twelve.part_one(
             TestUtils.Input.str_to_matrix("""
             OOOOO
             OXOXO
             OOOOO
             OXOXO
             OOOOO
             """)
           ) == 772

    assert Twelve.part_one(
             TestUtils.Input.str_to_matrix("""
             RRRRIICCFF
             RRRRIICCCF
             VVRRRCCFFF
             VVRCCCJFFF
             VVVVCJJCFE
             VVIVCCJJEE
             VVIIICJJEE
             MIIIIIJJEE
             MIIISIJEEE
             MMMISSJEEE
             """)
           ) == 1930
  end

  test "part_two" do
    assert Twelve.part_two(
             TestUtils.Input.str_to_matrix("""
             AAAA
             BBCD
             BBCC
             EEEC
             """)
           ) == 80

    assert Twelve.part_two(
             TestUtils.Input.str_to_matrix("""
             OOOOO
             OXOXO
             OOOOO
             OXOXO
             OOOOO
             """)
           ) == 436

    assert Twelve.part_two(
             TestUtils.Input.str_to_matrix("""
             EEEEE
             EXXXX
             EEEEE
             EXXXX
             EEEEE
             """)
           ) == 236

    assert Twelve.part_two(
             TestUtils.Input.str_to_matrix("""
             AAAAAA
             AAABBA
             AAABBA
             ABBAAA
             ABBAAA
             AAAAAA
             """)
           ) == 368

    assert Twelve.part_two(
             TestUtils.Input.str_to_matrix("""
             RRRRIICCFF
             RRRRIICCCF
             VVRRRCCFFF
             VVRCCCJFFF
             VVVVCJJCFE
             VVIVCCJJEE
             VVIIICJJEE
             MIIIIIJJEE
             MIIISIJEEE
             MMMISSJEEE
             """)
           ) == 1206
  end
end

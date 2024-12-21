defmodule SixteenTest do
  use ExUnit.Case
  alias AdventOfCode.Sixteen

  test "part_one" do
    assert Sixteen.part_one(
             TestUtils.Input.str_to_matrix("""
             ###E#
             #...#
             #.#.#
             #...#
             #S###
             #####
             """)
           ) == 3006

    assert Sixteen.part_one(
             TestUtils.Input.str_to_matrix("""
             ###############
             #.......#....E#
             #.#.###.#.###.#
             #.....#.#...#.#
             #.###.#####.#.#
             #.#.#.......#.#
             #.#.#####.###.#
             #...........#.#
             ###.#.#####.#.#
             #...#.....#.#.#
             #.#.#.###.#.#.#
             #.....#...#.#.#
             #.###.#.#.#.#.#
             #S..#.....#...#
             ###############
             """)
           ) == 7036

    assert Sixteen.part_one(
             TestUtils.Input.str_to_matrix("""
             #################
             #...#...#...#..E#
             #.#.#.#.#.#.#.#.#
             #.#.#.#...#...#.#
             #.#.#.#.###.#.#.#
             #...#.#.#.....#.#
             #.#.#.#.#.#####.#
             #.#...#.#.#.....#
             #.#.#####.#.###.#
             #.#.#.......#...#
             #.#.###.#####.###
             #.#.#...#.....#.#
             #.#.#.#####.###.#
             #.#.#.........#.#
             #.#.#.#########.#
             #S#.............#
             #################
             """)
           ) == 11_048
  end

  test "part_two" do
    assert Sixteen.part_two(
             TestUtils.Input.str_to_matrix("""
             ###E#
             ###.#
             #...#
             #.#.#
             #...#
             #S###
             #####
             """)
           ) == 11

    assert Sixteen.part_two(
             TestUtils.Input.str_to_matrix("""
             ###############
             #.......#....E#
             #.#.###.#.###.#
             #.....#.#...#.#
             #.###.#####.#.#
             #.#.#.......#.#
             #.#.#####.###.#
             #...........#.#
             ###.#.#####.#.#
             #...#.....#.#.#
             #.#.#.###.#.#.#
             #.....#...#.#.#
             #.###.#.#.#.#.#
             #S..#.....#...#
             ###############
             """)
           ) == 45

    assert Sixteen.part_two(
             TestUtils.Input.str_to_matrix("""
             #################
             #...#...#...#..E#
             #.#.#.#.#.#.#.#.#
             #.#.#.#...#...#.#
             #.#.#.#.###.#.#.#
             #...#.#.#.....#.#
             #.#.#.#.#.#####.#
             #.#...#.#.#.....#
             #.#.#####.#.###.#
             #.#.#.......#...#
             #.#.###.#####.###
             #.#.#...#.....#.#
             #.#.#.#####.###.#
             #.#.#.........#.#
             #.#.#.#########.#
             #S#.............#
             #################
             """)
           ) == 64
  end
end
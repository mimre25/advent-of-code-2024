defmodule TwentyFiveTest do
  use ExUnit.Case
  alias AdventOfCode.TwentyFive

  test "part_one" do
    assert TwentyFive.part_one(
             TestUtils.Input.str_to_list("""
             #####
             .####
             .####
             .####
             .#.#.
             .#...
             .....

             #####
             ##.##
             .#.##
             ...##
             ...#.
             ...#.
             .....

             .....
             #....
             #....
             #...#
             #.#.#
             #.###
             #####

             .....
             .....
             #.#..
             ###..
             ###.#
             ###.#
             #####

             .....
             .....
             .....
             #....
             #.#..
             #.#.#
             #####
             """)
           ) == 3
  end
end

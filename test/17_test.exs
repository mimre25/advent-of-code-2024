defmodule SeventeenTest do
  use ExUnit.Case
  alias AdventOfCode.Seventeen

  test "part_one" do
    assert Seventeen.part_one(
             TestUtils.Input.str_to_list("""
             Register A: 729
             Register B: 0
             Register C: 0

             Program: 0,1,5,4,3,0
             """)
           ) == "4,6,3,5,6,3,5,2,1,0"

    assert Seventeen.part_one(
             TestUtils.Input.str_to_list("""
             Register A: 117440
             Register B: 0
             Register C: 0

             Program: 0,3,5,4,3,0
             """)
           ) == "0,3,5,4,3,0"
  end

  test "part_two" do
    assert Seventeen.part_two(
             TestUtils.Input.str_to_list("""
             Register A: 2024
             Register B: 0
             Register C: 0

             Program: 0,3,5,4,3,0
             """)
           ) == 117_440
  end
end

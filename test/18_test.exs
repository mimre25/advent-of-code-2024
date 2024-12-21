defmodule EighteenTest do
  use ExUnit.Case
  alias AdventOfCode.Eighteen

  test "part_one" do
    assert Eighteen.part_one(
             TestUtils.Input.str_to_list("""
             5,4
             4,2
             4,5
             3,0
             2,1
             6,3
             2,4
             1,5
             0,6
             3,3
             2,6
             5,1
             1,2
             5,5
             2,5
             6,5
             1,4
             0,4
             6,4
             1,1
             6,1
             1,0
             0,5
             1,6
             2,0
             """),
             6,
             6,
             12
           ) == 22
  end

  test "part_two" do
    assert Eighteen.part_two(
             TestUtils.Input.str_to_list("""
             5,4
             4,2
             4,5
             3,0
             2,1
             6,3
             2,4
             1,5
             0,6
             3,3
             2,6
             5,1
             1,2
             5,5
             2,5
             6,5
             1,4
             0,4
             6,4
             1,1
             6,1
             1,0
             0,5
             1,6
             2,0
             """),
             6,
             6,
             12
           ) == "6,1"
  end
end

defmodule FourteenTest do
  use ExUnit.Case
  alias AdventOfCode.Fourteen

  test "part_one" do
    assert Fourteen.part_one(
             TestUtils.Input.str_to_list("""
             p=0,4 v=3,-3
             p=6,3 v=-1,-3
             p=10,3 v=-1,2
             p=2,0 v=2,-1
             p=0,0 v=1,3
             p=3,0 v=-2,-2
             p=7,6 v=-1,-3
             p=3,0 v=-1,-2
             p=9,3 v=2,3
             p=7,3 v=-1,2
             p=2,4 v=2,-3
             p=9,5 v=-3,-3
             """),
             height: 7,
             width: 11
           ) == 12
  end

  test "parse_robot" do
    assert Fourteen.parse_robot("p=0,4 v=3,-3\n") == {{0, 4}, {3, -3}}
  end
end

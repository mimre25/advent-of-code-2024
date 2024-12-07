defmodule SevenTest do
  use ExUnit.Case
  alias AdventOfCode.Seven

  test "part_one" do
    assert Seven.part_one(
             TestUtils.Input.str_to_list("""
             190: 10 19
             3267: 81 40 27
             83: 17 5
             156: 15 6
             7290: 6 8 6 15
             161011: 16 10 13
             192: 17 8 14
             21037: 9 7 18 13
             292: 11 6 16 20
             """)
           ) == 3749
  end

  test "part_two" do
    assert Seven.part_two(
             TestUtils.Input.str_to_list("""
             190: 10 19
             3267: 81 40 27
             83: 17 5
             156: 15 6
             7290: 6 8 6 15
             161011: 16 10 13
             192: 17 8 14
             21037: 9 7 18 13
             292: 11 6 16 20
             """)
           ) == 11_387
  end
end

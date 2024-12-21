defmodule TwentyOneTest do
  use ExUnit.Case
  alias AdventOfCode.TwentyOne

  setup do
    Memoization.init()
  end

  test "part_one" do
    assert TwentyOne.part_one(["029A", "980A", "179A", "456A", "379A"]) ==
             126_384
  end

  test "numpad" do
    assert TwentyOne.numpad(0, 3) == ["<vA", "v<A"]
    assert TwentyOne.numpad(0, 1) == [">vA"]
    assert TwentyOne.numpad("A", 1) == [">>vA", ">v>A"]
  end

  test "arrowpad" do
    assert TwentyOne.arrowpad("<", "A") == ["v<<A"]
    assert TwentyOne.arrowpad("v", "A") == ["<vA", "v<A"]
    assert TwentyOne.arrowpad(">", "A") == ["vA"]
    assert TwentyOne.arrowpad("^", "A") == ["<A"]
    assert TwentyOne.arrowpad("A", "<") == [">>^A"]
  end

  test "presses(029A)" do
    assert TwentyOne.presses(["0", "2", "9", "A"], 3, true) ==
             String.length(
               "<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A"
             )
  end

  test "presses(980A)" do
    assert TwentyOne.presses(["9", "8", "0", "A"], 3, true) ==
             String.length(
               "<v<A>>^AAAvA^A<vA<AA>>^AvAA<^A>A<v<A>A>^AAAvA<^A>A<vA>^A<A>A"
             )
  end

  test "presses(179A)" do
    assert TwentyOne.presses(["1", "7", "9", "A"], 3, true) ==
             String.length(
               "<v<A>>^A<vA<A>>^AAvAA<^A>A<v<A>>^AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A"
             )
  end

  test "presses(456A)" do
    assert TwentyOne.presses(["4", "5", "6", "A"], 3, true) ==
             String.length(
               "<v<A>>^AA<vA<A>>^AAvAA<^A>A<vA>^A<A>A<vA>^A<A>A<v<A>A>^AAvA<^A>A"
             )
  end

  test "presses(379A)" do
    assert TwentyOne.presses(["3", "7", "9", "A"], 3, true) ==
             String.length(
               "<v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A"
             )
  end
end

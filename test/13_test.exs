defmodule ThirteenTest do
  use ExUnit.Case
  alias AdventOfCode.Thirteen

  test "part_one" do
    assert Thirteen.part_one(
             TestUtils.Input.str_to_list("""
             Button A: X+94, Y+34
             Button B: X+22, Y+67
             Prize: X=8400, Y=5400

             Button A: X+26, Y+66
             Button B: X+67, Y+21
             Prize: X=12748, Y=12176

             Button A: X+17, Y+86
             Button B: X+84, Y+37
             Prize: X=7870, Y=6450

             Button A: X+69, Y+23
             Button B: X+27, Y+71
             Prize: X=18641, Y=10279
             """)
           ) == 480
  end

  test "parse_button" do
    assert Thirteen.parse_button("Button A: X+94, Y+34\n") ==
             {94, 34}

    assert Thirteen.parse_button("Button B: X+22, Y+774\n") ==
             {22, 774}
  end

  test "parse_prize" do
    assert Thirteen.parse_prize("Prize: X=4029, Y=1757\n") == {4029, 1757}
  end

  test "run_game" do
    assert Thirteen.play_game(
             {94, 34},
             {22, 67},
             {8400, 5400}
           ) == {80, 40}

    assert Thirteen.play_game(
             {26, 66},
             {67, 21},
             {12_748, 12_176}
           ) == nil
  end

  test "part_two" do
    assert Thirteen.part_two(
             TestUtils.Input.str_to_list("""
             Button A: X+94, Y+34
             Button B: X+22, Y+67
             Prize: X=8400, Y=5400

             Button A: X+26, Y+66
             Button B: X+67, Y+21
             Prize: X=12748, Y=12176

             Button A: X+17, Y+86
             Button B: X+84, Y+37
             Prize: X=7870, Y=6450

             Button A: X+69, Y+23
             Button B: X+27, Y+71
             Prize: X=18641, Y=10279
             """)
           ) == 875_318_608_908
  end
end

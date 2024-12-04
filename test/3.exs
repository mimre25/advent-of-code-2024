defmodule ThreeTest do
  use ExUnit.Case
  alias AdventOfCode.Three

  test "multiply" do
    assert Three.multiply("mul(3,4)") == 12
    assert Three.multiply("mul(10,25)") == 250
    assert Three.multiply("mul(100,100)") == 10_000
  end

  test "parse_mul" do
    assert Three.parse_mul(
             "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5)"
           ) == ["mul(2,4)", "mul(5,5)", "mul(11,8)", "mul(8,5)"]
  end

  test "test_part_one" do
    assert Three.part_one(
             "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5)"
           ) == 161
  end

  test "parse" do
    assert Three.parse(
             "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
           ) == [
             "mul(2,4)",
             "don't()",
             "mul(5,5)",
             "mul(11,8)",
             "do()",
             "mul(8,5)"
           ]
  end

  test "part_two" do
    assert Three.part_two(
             "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
           ) == 48
  end
end

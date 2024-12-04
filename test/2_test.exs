defmodule TwoTest do
  use ExUnit.Case
  alias AdventOfCode.Two

  test "test_monotonic" do
    assert Two.monotonic?([7, 6, 4, 2, 1])
    assert not Two.monotonic?([1, 2, 7, 8, 9])
    assert not Two.monotonic?([9, 7, 6, 2, 1])
    assert not Two.monotonic?([1, 3, 2, 4, 5])
    assert not Two.monotonic?([8, 6, 4, 4, 1])
    assert Two.monotonic?([1, 3, 6, 7, 9])
  end

  test "test_monotonic_with_tolerance" do
    assert Two.monotonic_with_tolerance?([7, 6, 4, 2, 1])
    assert not Two.monotonic_with_tolerance?([1, 2, 7, 8, 9])
    assert not Two.monotonic_with_tolerance?([9, 7, 6, 2, 1])
    assert Two.monotonic_with_tolerance?([1, 3, 2, 4, 5])
    assert Two.monotonic_with_tolerance?([8, 6, 4, 4, 1])
    assert Two.monotonic_with_tolerance?([1, 3, 6, 7, 9])
    assert Two.monotonic_with_tolerance?([48, 46, 47, 49, 51, 54, 56])
    assert Two.monotonic_with_tolerance?([1, 1, 2, 3, 4, 5])
    assert Two.monotonic_with_tolerance?([1, 2, 3, 4, 5, 5])
    assert Two.monotonic_with_tolerance?([5, 1, 2, 3, 4, 5])
    assert Two.monotonic_with_tolerance?([1, 4, 3, 2, 1])
    assert Two.monotonic_with_tolerance?([1, 6, 7, 8, 9])
    assert Two.monotonic_with_tolerance?([1, 2, 3, 4, 3])
    assert Two.monotonic_with_tolerance?([9, 8, 7, 6, 7])
    assert Two.monotonic_with_tolerance?([7, 10, 8, 10, 11])
    assert Two.monotonic_with_tolerance?([29, 28, 27, 25, 26, 25, 22, 20])
    assert Two.monotonic_with_tolerance?([7, 10, 8, 10, 11])
    assert Two.monotonic_with_tolerance?([29, 28, 27, 25, 26, 25, 22, 20])
    assert Two.monotonic_with_tolerance?([1, 3, 6, 5])
    assert Two.monotonic_with_tolerance?([2, 1, 3, 5])
    assert Two.monotonic_with_tolerance?([1, 3, 5, 4])
    assert Two.monotonic_with_tolerance?([1, 1, 3, 5])
    assert Two.monotonic_with_tolerance?([1, 3, 5, 5])
    assert Two.monotonic_with_tolerance?([1, 3, 3, 5])
    assert Two.monotonic_with_tolerance?([1, 2, 3, 5])
    assert Two.monotonic_with_tolerance?([40, 36, 38, 35, 33])
    assert Two.monotonic_with_tolerance?([33, 35, 38, 36, 40])
  end
end

defmodule ElevenTest do
  use ExUnit.Case
  alias AdventOfCode.Eleven

  test "part_one" do
    assert Eleven.part_one("125 17") == 55_312
  end
end

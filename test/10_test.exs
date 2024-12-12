defmodule TenTest do
  use ExUnit.Case
  alias AdventOfCode.Ten

  test "part_one" do
    assert Ten.part_one(
             TestUtils.Input.str_to_matrix("""
             89010123
             78121874
             87430965
             96549874
             45678903
             32019012
             01329801
             10456732
             """)
           ) == 36
  end

  test "part_two" do
    assert Ten.part_two(
             TestUtils.Input.str_to_matrix("""
             89010123
             78121874
             87430965
             96549874
             45678903
             32019012
             01329801
             10456732
             """)
           ) == 81
  end
end

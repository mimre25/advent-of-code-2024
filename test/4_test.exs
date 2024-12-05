defmodule FourTest do
  use ExUnit.Case
  alias AdventOfCode.Four
  doctest Four

  test "count_occurences" do
    assert Four.count_occurrences("...XMAS...XMAS...XMAS") == 3
  end

  test "transpose" do
    assert Four.transpose("""
           foo
           bar
           baz
           """) == """
           fbb
           oaa
           orz
           """
  end

  test "shifts" do
    assert Four.lshift("abcd", 1) == "bcd "
    assert Four.lshift("abcd", 2) == "cd  "
    assert Four.lshift("abcd", 3) == "d   "

    assert Four.rshift("abcd", 1) == " abc"
    assert Four.rshift("abcd", 2) == "  ab"
    assert Four.rshift("abcd", 3) == "   a"
  end

  test "build_diagonals" do
    assert Four.build_diagonals("""
           abc
           def
           ghi
           """) == [
             "aei",
             "bf ",
             "c  ",
             "a  ",
             "bd ",
             "ceg",
             "hf ",
             "i  ",
             "g  ",
             "hd "
           ]
  end

  test "part_one" do
    assert Four.part_one("""
           MMMSXXMASM
           MSAMXMSMSA
           AMXSXMAAMM
           MSAMASMSMX
           XMASAMXAMM
           XXAMMXXAMA
           SMSMSASXSS
           SAXAMASAAA
           MAMMMXMMMM
           MXMXAXMASX
           """) == 18
  end

  test "part_two" do
    assert Four.part_two_str("""
           MMMSXXMASM
           MSAMXMSMSA
           AMXSXMAAMM
           MSAMASMSMX
           XMASAMXAMM
           XXAMMXXAMA
           SMSMSASXSS
           SAXAMASAAA
           MAMMMXMMMM
           MXMXAXMASX
           """) == 9
  end
end

defmodule FiveTest do
  use ExUnit.Case
  alias AdventOfCode.Five

  test "parse_dependencies" do
    assert Five.parse_dependencies(["47|53", "97|13", "97|53"]) == %{
             "47" => ["53"],
             "97" => ["53", "13"]
           }
  end

  test "check_update?" do
    assert !Five.valid_update?("1,2,3", %{"3" => ["1"]})
    assert Five.valid_update?("1,2,3", %{"1" => ["2"]})
    assert !Five.valid_update?("1,2,3", %{"2" => ["1"]})
    assert !Five.valid_update?("1,2,3", %{"3" => ["2"]})
    assert Five.valid_update?("1,2,3", %{"2" => ["3"]})
  end

  test "part_one" do
    assert Five.part_one(
             TestUtils.Input.str_to_list("""
             47|53
             97|13
             97|61
             97|47
             75|29
             61|13
             75|53
             29|13
             97|29
             53|29
             61|53
             97|53
             61|29
             47|13
             75|47
             97|75
             47|61
             75|61
             47|29
             75|13
             53|13

             75,47,61,53,29
             97,61,53,29,13
             75,29,13
             75,97,47,61,53
             61,13,29
             97,13,75,29,47
             """)
           ) == 143
  end

  test "fix_incorrect_order" do
    map = %{
      "29" => ["13"],
      "47" => ["29", "61", "13", "53"],
      "53" => ["13", "29"],
      "61" => ["29", "53", "13"],
      "75" => ["13", "61", "47", "53", "29"],
      "97" => ["75", "53", "29", "47", "61", "13"]
    }

    assert Five.fix_incorrect_order(map, ["75", "97", "47", "61", "53"]) == [
             "97",
             "75",
             "47",
             "61",
             "53"
           ]

    assert Five.fix_incorrect_order(map, ["61", "13", "29"]) == [
             "61",
             "29",
             "13"
           ]

    assert Five.fix_incorrect_order(map, ["97", "13", "75", "29", "47"]) == [
             "97",
             "75",
             "47",
             "29",
             "13"
           ]
  end

  test "part_two" do
    assert Five.part_two(
             TestUtils.Input.str_to_list("""
             47|53
             97|13
             97|61
             97|47
             75|29
             61|13
             75|53
             29|13
             97|29
             53|29
             61|53
             97|53
             61|29
             47|13
             75|47
             97|75
             47|61
             75|61
             47|29
             75|13
             53|13

             75,47,61,53,29
             97,61,53,29,13
             75,29,13
             75,97,47,61,53
             61,13,29
             97,13,75,29,47
             """)
           ) == 123
  end
end

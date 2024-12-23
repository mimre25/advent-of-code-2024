defmodule TwentyThreeTest do
  use ExUnit.Case
  alias AdventOfCode.TwentyThree

  test "part_one" do
    assert TwentyThree.part_one(
             TestUtils.Input.str_to_list("""
             kh-tc
             qp-kh
             de-cg
             ka-co
             yn-aq
             qp-ub
             cg-tb
             vc-aq
             tb-ka
             wh-tc
             yn-cg
             kh-ub
             ta-co
             de-co
             tc-td
             tb-wq
             wh-td
             ta-ka
             td-qp
             aq-cg
             wq-ub
             ub-vc
             de-ta
             wq-aq
             wq-vc
             wh-yn
             ka-de
             kh-ta
             co-tc
             wh-qp
             tb-vc
             td-yn
             """)
           ) == 7
  end

  test "part_two" do
    assert TwentyThree.part_two(
             TestUtils.Input.str_to_list("""
             kh-tc
             qp-kh
             de-cg
             ka-co
             yn-aq
             qp-ub
             cg-tb
             vc-aq
             tb-ka
             wh-tc
             yn-cg
             kh-ub
             ta-co
             de-co
             tc-td
             tb-wq
             wh-td
             ta-ka
             td-qp
             aq-cg
             wq-ub
             ub-vc
             de-ta
             wq-aq
             wq-vc
             wh-yn
             ka-de
             kh-ta
             co-tc
             wh-qp
             tb-vc
             td-yn
             """)
           ) == "co,de,ka,ta"
  end
end

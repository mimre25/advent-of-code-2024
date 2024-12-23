defmodule Mix.Tasks.Main do
  @moduledoc false
  use Mix.Task

  @impl Mix.Task
  def run([day | _]) do
    case String.to_integer(day) do
      1 -> AdventOfCode.One.main()
      2 -> AdventOfCode.Two.main()
      3 -> AdventOfCode.Three.main()
      4 -> AdventOfCode.Four.main()
      5 -> AdventOfCode.Five.main()
      6 -> AdventOfCode.Six.main()
      7 -> AdventOfCode.Seven.main()
      8 -> AdventOfCode.Eight.main()
      9 -> AdventOfCode.Nine.main()
      10 -> AdventOfCode.Ten.main()
      11 -> AdventOfCode.Eleven.main()
      12 -> AdventOfCode.Twelve.main()
      13 -> AdventOfCode.Thirteen.main()
      14 -> AdventOfCode.Fourteen.main()
      15 -> AdventOfCode.Fifteen.main()
      16 -> AdventOfCode.Sixteen.main()
      17 -> AdventOfCode.Seventeen.main()
      18 -> AdventOfCode.Eighteen.main()
      19 -> AdventOfCode.Nineteen.main()
      20 -> AdventOfCode.Twenty.main()
      21 -> AdventOfCode.TwentyOne.main()
      22 -> AdventOfCode.TwentyTwo.main()
      23 -> AdventOfCode.TwentyThree.main()
      _ -> IO.puts("Day #{day} not implemented yet")
    end
  end
end

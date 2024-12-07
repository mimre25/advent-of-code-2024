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
      _ -> IO.puts("Day #{day} not implemented yet")
    end
  end
end

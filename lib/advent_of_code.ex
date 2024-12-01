defmodule Mix.Tasks.Main do
  @moduledoc false
  use Mix.Task

  @impl Mix.Task
  def run([day | _]) do
    case String.to_integer(day) do
      1 -> AdventOfCode.One.main()
      _ -> IO.puts("Day #{day} not implemented yet")
    end
  end
end

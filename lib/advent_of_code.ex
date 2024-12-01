defmodule Mix.Tasks.Main do
  @moduledoc false
  use Mix.Task

  @impl Mix.Task
  def run(day) do
    IO.puts("hi #{day}")
    Mix.shell().info("Hello world")
  end
end

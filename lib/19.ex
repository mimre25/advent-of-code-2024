defmodule AdventOfCode.Nineteen do
  @moduledoc false

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(19) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(19) |> part_two() |> IO.puts()
  end

  @doc """
    Count the designs that we can create with the given patterns
  """
  def part_one(input) do
    r =
      input
      |> Enum.at(0)
      |> String.split(~r/ |,|\n/, trim: true)
      |> Enum.join("|")

    regex = ~r/^(#{r})+\n$/

    input
    |> Enum.drop(2)
    |> Enum.map(fn e -> Regex.match?(regex, e) end)
    |> Enum.count(&Function.identity/1)
  end

  defp find_step(patterns, design) do
    patterns
    |> Enum.reduce(0, fn pattern, acc ->
      if String.starts_with?(design, pattern) do
        ^pattern <> rest = design
        acc + find_from_start(patterns, rest)
      else
        acc + 0
      end
    end)
  end

  @spec find_from_start([String.t()], String.t()) :: non_neg_integer()
  defp find_from_start(_, ""), do: 1

  defp find_from_start(patterns, design) do
    memo = Agent.get(Memo, fn m -> Map.get(m, design) end)

    res =
      if memo != nil do
        memo
      else
        find_step(patterns, design)
      end

    Agent.update(Memo, fn m -> Map.put(m, design, res) end)
    res
  end

  @doc """
    Compute how all possible ways to create a design from the given patterns and count them
  """
  def part_two(input) do
    patterns =
      input
      |> Enum.at(0)
      |> String.split(~r/ |,|\n/, trim: true)

    r = patterns |> Enum.join(")|(")
    regex = ~r/^((#{r}))+\n$/

    designs =
      input
      |> Enum.drop(2)
      |> Enum.filter(fn e -> Regex.match?(regex, e) end)
      |> Enum.map(fn x -> String.replace(x, ~r/\n/, "") end)

    patterns =
      patterns
      |> Enum.sort(fn a, b -> String.length(a) >= String.length(b) end)

    _ = Agent.start_link(fn -> %{} end, name: Memo)

    Progress.init()
    Progress.add_total(Enum.count(designs))
    Progress.render()

    designs
    |> Enum.reduce(0, fn design, acc ->
      res = find_from_start(patterns, design)
      Progress.add_done()
      Progress.render()
      acc + res
    end)
  end
end

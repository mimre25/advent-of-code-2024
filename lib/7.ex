defmodule AdventOfCode.Seven do
  @moduledoc false

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(7) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(7) |> part_two() |> IO.puts()
  end

  @spec step(non_neg_integer(), [non_neg_integer()], [
          (non_neg_integer(), non_neg_integer() -> non_neg_integer())
        ]) :: [non_neg_integer()]
  defp step(acc, [], _) do
    [acc]
  end

  defp step(acc, [val | remainder], ops) do
    Enum.flat_map(ops, fn op -> step(op.(acc, val), remainder, ops) end)
  end

  defp check_line(sum, [fst | nums], ops) do
    step(fst, nums, ops) |> Enum.any?(fn x -> x == sum end)
  end

  @spec concat_nums(non_neg_integer(), non_neg_integer()) :: non_neg_integer()
  defp concat_nums(x, y) do
    String.to_integer(Integer.to_string(x) <> Integer.to_string(y))
  end

  @spec run_line(String.t(), [
          (non_neg_integer(), non_neg_integer() -> non_neg_integer())
        ]) :: non_neg_integer()
  defp run_line(line, ops) do
    if line == "\n" do
      0
    else
      [s, parts] = String.split(line, ~r/:|\n/, trim: true)
      sum = String.to_integer(s)

      nums =
        String.split(parts, " ", trim: true) |> Enum.map(&String.to_integer/1)

      (check_line(sum, nums, ops) && sum) || 0
    end
  end

  @doc """
    Check each line whether the first number can be calculated according to rules and sums those lines

    The ruels are
    1. left to right
    2. only allow + and *
  """
  def part_one(input) do
    Enum.map(input, fn line -> run_line(line, [&+/2, &*/2]) end) |> Enum.sum()
  end

  @doc """
    Check each line whether the first number can be calculated according to rules and sums those lines

    The ruels are
    1. left to right
    2. only allow + and *, and concatenation (12 || 345 = 12345)
  """
  def part_two(input) do
    Enum.map(input, fn line -> run_line(line, [&+/2, &*/2, &concat_nums/2]) end)
    |> Enum.sum()
  end
end

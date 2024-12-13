defmodule AdventOfCode.Eleven do
  @moduledoc false

  require Integer

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_string(11) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_string(11) |> part_two() |> IO.puts()
  end

  @spec apply_rule(non_neg_integer()) :: [non_neg_integer()]
  @doc """
    Apply the correct rule for a given stone value

    If the stone is engraved with the number 0, it is replaced by a stone
    engraved with the number 1.

    If the stone is engraved with a number that has an even number of digits,
    it is replaced by two stones. The left half of the digits are engraved on
    the new left stone, and the right half of the digits are engraved on the
    new right stone. (The new numbers don't keep extra leading zeroes: 1000
    would become stones 10 and 0.)

    If none of the other rules apply, the stone is replaced by a new stone; the
    old stone's number multiplied by 2024 is engraved on the new stone.
  """
  # rule 1
  def apply_rule(0), do: [1]

  def apply_rule(value) do
    digits = Integer.digits(value)
    num_digits = Enum.count(digits)
    # rule 2
    if Integer.is_even(num_digits) do
      digits
      |> Enum.split(Integer.floor_div(num_digits, 2))
      |> Tuple.to_list()
      |> Enum.map(&Integer.undigits/1)
    else
      # rule 3
      [value * 2024]
    end
  end

  defp apply_rules(stones, iteration, total_iterations)
       when iteration == total_iterations do
    stones
  end

  defp apply_rules(stones, iteration, total_iterations) do
    stones
    |> Map.to_list()
    |> Enum.reduce(%{}, fn {stone, frequency}, acc ->
      apply_rule(stone)
      |> Enum.reduce(acc, fn x, inner_acc ->
        Map.update(inner_acc, x, frequency, &(&1 + frequency))
      end)
    end)
    |> tap(fn _ -> Progress.add_done() end)
    |> apply_rules(iteration + 1, total_iterations)
  end

  @doc """
    Apply the blinking rules to the stones 25 times
  """
  def part_one(input) do
    Progress.init()
    Progress.add_total(25)

    res =
      input
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> apply_rules(0, 25)
      |> Map.values()
      |> Enum.sum()

    Progress.stop()
    res
  end

  @doc """
    Apply the blinking rules to the stones 75 times
  """
  def part_two(input) do
    Progress.init()
    Progress.add_total(75)

    res =
      input
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> apply_rules(0, 75)
      |> Map.values()
      |> Enum.sum()

    Progress.stop()
    res
  end
end

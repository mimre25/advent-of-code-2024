defmodule AdventOfCode.One do
  @moduledoc false
  @doc false
  def main() do
    IO.puts("Part one:")
    part_one()
    IO.puts("Part two:")
    part_two()
  end

  @doc """
    Compare the two lists given in the input to see the total difference.
    The difference is computed as the difference between the nth element of
    each list after sorting.
  """
  def part_one() do
    data = Input.get_input(1)

    data
    |> Enum.map(fn l ->
      String.split(l, ~r" |\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
    |> Enum.map(fn list -> Tuple.to_list(list) |> Enum.sort() end)
    |> Enum.zip_reduce([], fn [l, r], acc -> [abs(l - r) | acc] end)
    |> Enum.sum()
    |> IO.puts()
  end

  @doc """
    Computes the "similarity" of the input lists by multiplying each number
    in the first list with the amoun of occurences in the second list and
    sums up the products.
  """
  def part_two() do
    data = Input.get_input(1)

    [left, right] =
      data
      |> Enum.map(fn l ->
        String.split(l, ~r" |\n", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.zip()
      |> Enum.map(fn list -> Tuple.to_list(list) end)

    frequencies = Enum.frequencies(right)

    Enum.uniq(left)
    |> Enum.map(fn e -> Map.get(frequencies, e, 0) * e end)
    |> Enum.sum()
    |> IO.puts()
  end
end

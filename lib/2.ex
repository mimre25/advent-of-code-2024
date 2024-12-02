defmodule AdventOfCode.Two do
  @moduledoc false
  @doc false
  def main() do
    IO.puts("Part one:")
    part_one()
    IO.puts("Part two:")
    part_two()
  end

  @spec monotonic?(Enumerable.t()) :: boolean()
  def monotonic?([fst, snd | _]) when fst == snd do
    false
  end

  def monotonic?(list) do
    [fst, snd | tail] = list

    op =
      if fst > snd do
        fn a, b -> a > b and b >= a - 3 end
      else
        fn a, b -> a < b and b <= a + 3 end
      end

    Enum.zip_reduce([list, [snd | tail]], true, fn [a, b], acc ->
      acc && op.(a, b)
    end)
  end

  @spec monotonic?(Enumerable.t()) :: boolean()
  def monotonic_with_tolerance?([fst, snd | tail]) when fst == snd do
    monotonic?([snd | tail])
  end

  def monotonic_with_tolerance?(list) do
    [fst, snd | tail] = list

    op =
      if fst > snd do
        fn a, b -> a > b and b >= a - 3 end
      else
        fn a, b -> a < b and b <= a + 3 end
      end

    simple_test =
      Enum.zip_with([list, [snd | tail]], fn [a, b] -> op.(a, b) end)

    idx = Enum.find_index(simple_test, &not/1)

    if is_nil(idx) do
      true
    else
      # try with the first of the bad pair removed
      {fst_ls, [_ | snd_ls]} = Enum.split(list, idx)
      fst_test = monotonic?(Enum.concat([fst_ls, snd_ls]))
      # try with the second of the bad pair removed
      {fst_ls, [_ | snd_ls]} = Enum.split(list, idx + 1)
      snd_test = monotonic?(Enum.concat([fst_ls, snd_ls]))

      fst_test or snd_test or
        monotonic?([snd | tail]) or
        monotonic?(Enum.take(list, Enum.count(list) - 1))
    end
  end

  @doc """
    Check how many input lines are safe.
    A safe line is strict monotonic with a max diff of 3 for adjacent entries.
  """
  def part_one() do
    data = Input.get_input(2)

    data
    |> Enum.map(fn l ->
      String.split(l, ~r" |\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> monotonic?()
    end)
    |> Enum.count(&Function.identity/1)
    |> IO.puts()
  end

  @doc """
    Check how many input lines are safe with a tolerance of 1.
    Tolerance meaning, that we allow the removal of 1 element and rechecking.
  """
  def part_two() do
    data = Input.get_input(2)

    data
    |> Enum.map(fn l ->
      String.split(l, ~r" |\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> monotonic_with_tolerance?()
    end)
    |> Enum.count(&Function.identity/1)
    |> IO.puts()
  end
end

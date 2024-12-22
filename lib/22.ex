defmodule AdventOfCode.TwentyTwo do
  @moduledoc false

  @typep sequence :: {integer(), integer(), integer(), integer()}

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(22) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(22) |> part_two() |> IO.puts()
  end

  @spec mix(non_neg_integer(), non_neg_integer()) :: non_neg_integer()
  @doc """
     To mix a value into the secret number, calculate the bitwise XOR of the given
     value and the secret number. Then, the secret number becomes the result of
     that operation. (If the secret number is 42 and you were to mix 15 into the
     secret number, the secret number would become 37.)
  """
  def mix(value, secret) do
    Bitwise.bxor(value, secret)
  end

  @spec prune(non_neg_integer()) :: non_neg_integer()
  @doc """
    To prune the secret number, calculate the value of the secret number modulo
    16777216. Then, the secret number becomes the result of that operation. (If
    the secret number is 100000000 and you were to prune the secret number, the
    secret number would become 16113920.)
  """
  def prune(secret) do
    Integer.mod(secret, 16_777_216)
  end

  @spec pnr(non_neg_integer(), non_neg_integer()) :: [non_neg_integer()]
  @doc """
    In particular, each buyer's secret number evolves into the next secret
    number in the sequence via the following process:

    - Calculate the result of multiplying the secret number by 64. Then, mix this
    result into the secret number. Finally, prune the secret number.
    - Calculate the result of dividing the secret number by 32. Round the result
    down to the nearest integer. Then, mix this result into the secret number.
    Finally, prune the secret number.
    - Calculate the result of multiplying the secret number by 2048. Then, mix
    this result into the secret number. Finally, prune the secret number.

  """
  def pnr(secret, iterations)

  def pnr(secret, 0), do: [secret]

  def pnr(secret, iterations) do
    step_1 = mix_and_prune(secret, secret * 64)
    step_2 = mix_and_prune(step_1, div(step_1, 32))
    new_secret = mix_and_prune(step_2, 2048 * step_2)

    [secret | pnr(new_secret, iterations - 1)]
  end

  @spec mix_and_prune(non_neg_integer(), non_neg_integer()) :: non_neg_integer()
  defp mix_and_prune(secret, value) do
    prune(mix(secret, value))
  end

  @doc """
    Find the sum of all pseudo-random numbers in after running the pnr 2000 iterations on the given seeds
  """
  def part_one(input) do
    input
    |> Enum.reject(&(&1 == "\n"))
    |> Enum.map(fn s ->
      String.split(s, ~r/\n/, trim: true) |> Enum.join() |> String.to_integer()
    end)
    |> Enum.map(&(pnr(&1, 2000) |> Enum.at(-1)))
    |> Enum.sum()
  end

  @spec derive_prices([non_neg_integer()]) :: [non_neg_integer()]
  defp derive_prices(secrets) do
    secrets |> Enum.map(fn s -> Integer.mod(s, 10) end)
  end

  @spec derive_prices([non_neg_integer()]) :: {[non_neg_integer()], [integer()]}
  defp changes(prices) do
    {Enum.drop(prices, 1),
     Enum.zip_with(
       [
         Enum.drop(prices, 1),
         prices
       ],
       fn [fst, snd] -> fst - snd end
     )}
  end

  @spec build_sequence_values({[non_neg_integer()], [integer()]}) :: %{
          sequence() => non_neg_integer()
        }
  defp build_sequence_values({prices, changes}) do
    reducer = fn [{_, fst}, {_, snd}, {_, thrd}, {value, fourth}],
                 acc = {seen, sequence_values} ->
      sequence = {fst, snd, thrd, fourth}

      if MapSet.member?(seen, sequence) do
        acc
      else
        {MapSet.put(seen, sequence), Map.put(sequence_values, sequence, value)}
      end
    end

    {_, res} =
      Enum.zip(prices, changes)
      |> Enum.chunk_every(4, 1, :discard)
      |> Enum.reduce({MapSet.new(), %{}}, reducer)

    res
  end

  @spec evaluate_sequences([%{sequence() => non_neg_integer()}]) :: %{
          sequence() => non_neg_integer()
        }
  defp evaluate_sequences(sequence_values) do
    sequence_values
    |> Enum.reduce(%{}, fn e, acc ->
      acc = Map.merge(acc, e, fn _, v1, v2 -> v1 + v2 end)
      Progress.add_done()
      acc
    end)
  end

  @doc """
    Compute the best total price we can get from the monkeys
  """
  def part_two(input) do
    Progress.init()

    input
    |> Enum.reject(&(&1 == "\n"))
    |> tap(fn e -> Progress.add_total(Enum.count(e)) end)
    |> Enum.map(fn s ->
      String.split(s, ~r/\n/, trim: true) |> Enum.join() |> String.to_integer()
    end)
    |> Enum.map(fn seed ->
      res =
        seed
        |> pnr(2000)
        |> derive_prices()
        |> changes()
        |> build_sequence_values()

      Progress.add_done()
      res
    end)
    |> tap(fn e ->
      Progress.stop()
      Progress.init()
      Progress.add_total(Enum.count(e))
    end)
    |> evaluate_sequences()
    |> Map.values()
    |> Enum.max()
  end
end

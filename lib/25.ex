defmodule AdventOfCode.TwentyFive do
  @moduledoc false

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(25) |> part_one() |> IO.puts()
  end

  defp key?("#####"), do: false
  defp key?("....."), do: true

  defp parse_schematic(schematic) do
    {key?(Enum.at(schematic, 0)),
     schematic
     |> Enum.reduce([-1, -1, -1, -1, -1], fn s, acc ->
       s
       |> String.replace("#", "1")
       |> String.replace(".", "0")
       |> String.split("", trim: true)
       |> Enum.map(&String.to_integer/1)
       |> Enum.zip_with(acc, &(&1 + &2))
     end)}
  end

  defp parse(input) do
    {keys, locks} =
      input
      |> Enum.map(&String.replace(&1, "\n", ""))
      |> Enum.chunk_every(7, 8)
      |> Enum.map(&parse_schematic/1)
      |> Enum.split_with(fn {key, _} -> key end)

    {
      Enum.map(keys, fn {_, v} -> v end),
      Enum.map(locks, fn {_, v} -> v end)
    }
  end

  defp fit?(key, lock) do
    Enum.zip_with(key, lock, &(&1 + &2)) |> Enum.all?(&(&1 <= 5))
  end

  defp count_fits(keys, locks, fits)
  defp count_fits([], _, fits), do: fits

  defp count_fits([key | keys], locks, fits) do
    fits =
      fits +
        Enum.reduce(locks, 0, fn lock, acc ->
          if fit?(key, lock) do
            acc + 1
          else
            acc
          end
        end)

    count_fits(keys, locks, fits)
  end

  @doc """
    Find how many keys fit in how many locks
  """
  def part_one(input) do
    {keys, locks} = input |> parse()
    count_fits(keys, locks, 0)
  end
end

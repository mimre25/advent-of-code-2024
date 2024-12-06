defmodule AdventOfCode.Five do
  @moduledoc false

  @typep depdency_map :: %{String.t() => [String.t()]}

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(5) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(5) |> part_two() |> IO.puts()
  end

  @spec parse_dependencies([String.t()]) :: depdency_map()
  @doc """
    Parse dependency lines returning a map mapping from number to list of depdencies
  """
  def parse_dependencies(lines) do
    Enum.reduce(lines, %{}, fn line, map ->
      [num, dep] = String.split(line, ~r/\||\n/, trim: true)
      Map.update(map, num, [dep], fn deps -> [dep | deps] end)
    end)
  end

  @spec valid_update?(String.t(), depdency_map()) :: boolean()
  def valid_update?(update, _) when update == "\n" do
    false
  end

  @spec valid_update?(String.t(), depdency_map()) :: boolean()
  @doc """
    Checks if an "update" is valied according to the depdencies given

    An update is only valid if the order does not violate the depdencies
  """
  def valid_update?(update, deps) do
    {violated_deps, _} =
      String.split(update, ~r/,|\n/, trim: true)
      |> Enum.map_reduce([], fn entry, previous_entries ->
        {
          (
            entries_deps = Map.get(deps, entry, [])

            Enum.any?(previous_entries, fn e ->
              Enum.member?(entries_deps, e)
            end)
          ),
          [entry | previous_entries]
        }
      end)

    !Enum.any?(violated_deps)
  end

  @spec extract_update_value(String.t()) :: integer()
  defp extract_update_value_str(update) do
    String.split(update, ~r/,|\n/, trim: true) |> extract_update_value()
  end

  @spec extract_update_value([String.t()]) :: integer()
  defp extract_update_value(update) do
    entries =
      update
      |> Enum.map(&String.to_integer/1)

    Enum.fetch!(entries, Integer.floor_div(Enum.count(entries), 2))
  end

  @doc """
    Filters for correct "updates" and sums the values in the middle of each
  """
  def part_one(input) do
    {deps, updates} = Enum.split_while(input, fn l -> l != "\n" end)
    deps = parse_dependencies(deps)

    Enum.map(updates, fn update -> {valid_update?(update, deps), update} end)
    |> Enum.reduce(0, fn {valid, update}, acc ->
      if valid do
        extract_update_value_str(update) + acc
      else
        acc
      end
    end)
  end

  @spec fix_incorrect_order(depdency_map(), [String.t()]) :: [String.t()]
  @doc """
    Fixes the order of an incorrect update based on the given depdencies
  """
  def fix_incorrect_order(depdencies, update) do
    Enum.sort(update, fn a, b ->
      b_deps = Map.get(depdencies, b, [])

      if Enum.member?(b_deps, a) do
        false
      else
        true
      end
    end)
  end

  @doc """
    Fixes all incorrect "updates" and sums the values in the middle of each
  """
  def part_two(input) do
    {deps, updates} = Enum.split_while(input, fn l -> l != "\n" end)
    deps = parse_dependencies(deps)

    Enum.filter(updates, fn update ->
      update != "\n" && !valid_update?(update, deps)
    end)
    |> Enum.map(fn x -> String.split(x, ~r/,|\n/, trim: true) end)
    |> Enum.reduce(0, fn update, acc ->
      fixed_update = fix_incorrect_order(deps, update)
      extract_update_value(fixed_update) + acc
    end)
  end
end

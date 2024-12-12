defmodule AdventOfCode.Eight do
  @moduledoc false

  @typep matrix :: Types.matrix(String.t())
  @typep position :: {non_neg_integer(), non_neg_integer()}

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_matrix(8) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_matrix(8) |> part_two() |> IO.puts()
  end

  @spec compute_antinode_positions(position(), position()) :: [position()]
  @doc """
    Compute the position of all antinodes for the given two antennas

    An antinode is positioned on the line that is given by the two antennas,
    and always twice as far away from one antenna to another.
    Each antenna pair has two antinodes.
  """
  def compute_antinode_positions({x, y}, {w, u}) do
    diff_x = w - x
    diff_y = u - y
    [{x - diff_x, y - diff_y}, {w + diff_x, u + diff_y}]
  end

  @spec compute_antinode_positions_with_frequency(
          position(),
          position(),
          non_neg_integer()
        ) :: [position()]
  @doc """
    Compute the position of all antinodes for the resonant frequency given by the two antennas

    An antinode is positioned on the line that is given by the two antennas,
    on every point that hits the resonant frequency of the two antinodes.
  """
  def compute_antinode_positions_with_frequency({x, y}, {w, u}, field_size) do
    diff_x = w - x
    diff_y = u - y

    antinode_positions =
      for k <- 0..field_size do
        diff_x_ = diff_x * k
        diff_y_ = diff_y * k
        [{x - diff_x_, y - diff_y_}, {w + diff_x_, u + diff_y_}]
      end

    Enum.concat(antinode_positions) |> Enum.uniq()
  end

  defp antinode_inside_field?({x, y}, field_size) do
    x > 0 && y > 0 && x <= field_size && y <= field_size
  end

  defp antenna?("."), do: false
  defp antenna?(_), do: true

  @spec find_antennas(matrix()) :: %{String.t() => [position()]}
  @doc """
    Find all the antennas in the field

    In addition to finding antennas, this function also adds 1 to their coordinate
    to transform the "game" into a coordinate system indexed by 1.
  """
  def find_antennas(field) do
    field
    |> Enum.flat_map(fn {x, row} ->
      row
      |> Enum.filter(fn {_, c} -> antenna?(c) end)
      |> Enum.map(fn {y, c} ->
        {x + 1, y + 1, c}
      end)
    end)
    |> Enum.group_by(fn {_, _, c} -> c end, fn {x, y, _} -> {x, y} end)
  end

  defp cartesian(list) do
    for i <- list, j <- list do
      {i, j}
    end
  end

  @spec compute_all_antinode_positions([position()]) :: [position()]
  defp compute_all_antinode_positions(positions) do
    cartesian(positions)
    |> Enum.filter(fn {x, y} -> x != y end)
    |> Enum.flat_map(fn {pos1, pos2} ->
      compute_antinode_positions(pos1, pos2)
    end)
  end

  @doc """
    Count how many antinodes are given by the antennas in the field

    This part is based on the simple rule that each antenna pair only has two antinodes.
  """
  def part_one(input) do
    field_size = Enum.max(Map.keys(input)) + 1
    antenna_map = find_antennas(input)

    antenna_map
    |> Enum.flat_map(fn {_, positions} ->
      compute_all_antinode_positions(positions)
    end)
    |> Enum.filter(fn pos -> antinode_inside_field?(pos, field_size) end)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.count()
  end

  @spec compute_all_antinode_positions_with_frequencies(
          [position()],
          non_neg_integer()
        ) :: [position()]
  defp compute_all_antinode_positions_with_frequencies(positions, field_size) do
    cartesian(positions)
    |> Enum.filter(fn {x, y} -> x != y end)
    |> Enum.flat_map(fn {pos1, pos2} ->
      compute_antinode_positions_with_frequency(pos1, pos2, field_size)
    end)
  end

  @doc """
    Count how many antinodes are given by the antennas in the field

    This part isbased on the rule that each antenna pair has an antinode at every
    position that lies on the line and follows the resonant frequency (= multiple of
    their distances from each other) of the antennas.
  """
  def part_two(input) do
    field_size = Enum.max(Map.keys(input)) + 1
    antenna_map = find_antennas(input)

    antenna_map
    |> Enum.flat_map(fn {_, positions} ->
      compute_all_antinode_positions_with_frequencies(positions, field_size)
    end)
    |> Enum.filter(fn pos -> antinode_inside_field?(pos, field_size) end)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.count()
  end
end

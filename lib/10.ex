defmodule AdventOfCode.Ten do
  @moduledoc false
  require Integer

  @typep matrix :: Types.matrix(integer())
  @typep position :: {non_neg_integer(), non_neg_integer(), non_neg_integer()}
  @typep path :: {
           position(),
           position(),
           position(),
           position(),
           position(),
           position(),
           position(),
           position(),
           position()
         }

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_matrix(10) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_matrix(10) |> part_two() |> IO.puts()
  end

  @spec build_path(
          matrix(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer()
        ) :: [path()]
  @doc """
    Build a path starting at the given position and height

    Paths are only valid if the start with height 0.
    Visits a 4-neighborhood to continue building the path with height+1 until
    a height of 9 is reached, whereupon the path is returned.

    Only continues building the path for a neighbor that is of height+1.

    This results only in paths that are strictly monotonicly increasing from 0 to 9.
  """
  def build_path(map, i, j, height) when height == 0 do
    [
      build_path(map, i - 1, j, height + 1, [{i, j, 0}]),
      build_path(map, i + 1, j, height + 1, [{i, j, 0}]),
      build_path(map, i, j - 1, height + 1, [{i, j, 0}]),
      build_path(map, i, j + 1, height + 1, [{i, j, 0}])
    ]
    |> Enum.flat_map(fn l -> l |> Enum.reject(&(&1 == [])) end)
  end

  def build_path(_, _, _, height) when height != 0 do
    []
  end

  @spec build_path(
          matrix(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          [position()]
        ) :: [path()]
  def build_path(map, i, j, height, path) when height == 9 do
    if map[i][j] == height do
      [List.to_tuple(Enum.reverse([{i, j, height} | path]))]
    else
      []
    end
  end

  def build_path(map, i, j, height, path) do
    if map[i][j] == height do
      [
        build_path(map, i - 1, j, height + 1, [{i, j, height} | path]),
        build_path(map, i + 1, j, height + 1, [{i, j, height} | path]),
        build_path(map, i, j - 1, height + 1, [{i, j, height} | path]),
        build_path(map, i, j + 1, height + 1, [{i, j, height} | path])
      ]
      |> Enum.flat_map(fn l -> l |> Enum.reject(&(&1 == [])) end)
    else
      []
    end
  end

  @spec find_and_count_paths(matrix(), (path() -> {position(), position()})) ::
          non_neg_integer()
  @doc """
    Find every path on the map and counts them

    Tries to build a path for every position on the map.
    A Path is only valid if it's strict monotonicly increasing from 0 to 9.
  """
  def find_and_count_paths(map, path_id_fun) do
    map
    |> Enum.flat_map(fn {i, row} ->
      Enum.flat_map(row, fn {j, height} ->
        build_path(map, i, j, height) |> Enum.reject(&(&1 == []))
      end)
      |> Enum.reject(&(&1 == []))
    end)
    |> Enum.reject(&(&1 == []))
    |> Enum.sort(fn t1, t2 ->
      path_id_fun.(t1) <=
        path_id_fun.(t2)
    end)
    |> Enum.dedup_by(path_id_fun)
    |> Enum.count()
  end

  @doc """
    Count the number of possible trail ends that can be reach from trail heads
  """
  def part_one(input) do
    Types.string_to_integer(input)
    |> find_and_count_paths(fn t -> {elem(t, 0), elem(t, 9)} end)
  end

  @doc """
    Count the number of possible trails
  """
  def part_two(input) do
    Types.string_to_integer(input) |> find_and_count_paths(&Function.identity/1)
  end
end

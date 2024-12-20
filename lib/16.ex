# credo:disable-for-this-file
defmodule AdventOfCode.Sixteen do
  @moduledoc false
  @east {0, 1}
  @west {0, -1}
  @north {-1, 0}
  @south {1, 0}

  @type direction :: {-1, 0} | {1, 0} | {0, -1} | {0, 1}
  @type vertex :: {non_neg_integer(), non_neg_integer()}
  @type graph :: %{vertex() => String.t() | integer()}
  @type pos :: {vertex(), direction()}
  @type cost :: non_neg_integer()
  @type pathlist :: [[pos()]]

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_matrix(16) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_matrix(16) |> part_two() |> IO.puts()
  end

  defp opposite(@south), do: @north
  defp opposite(@north), do: @south
  defp opposite(@east), do: @west
  defp opposite(@west), do: @east

  defp neighbors({{i, j}, direction}) do
    [
      {{i + 1, j}, @south},
      {{i - 1, j}, @north},
      {{i, j + 1}, @east},
      {{i, j - 1}, @west}
    ]
    |> Enum.reject(fn {_, dir} -> opposite(direction) == dir end)
  end

  defp compute_cost({_, dir_from}, {_, dir_to}) do
    cond do
      dir_from == dir_to -> 1
      true -> 1001
    end
  end

  def prepend_to_paths(paths, pos) do
    Enum.map(paths, fn p -> [pos | p] end)
  end

  defp continue_shortest_path(
         world,
         visited,
         queue,
         pos,
         cost,
         new_paths,
         max_cost
       ) do
    queue =
      neighbors(pos)
      |> Enum.reduce(queue, fn e, acc ->
        {e_pos, _} = e

        cond do
          Map.has_key?(visited, e) ->
            acc

          Map.get(world, e_pos) == "#" ->
            acc

          Map.has_key?(world, e_pos) ->
            [{cost + compute_cost(pos, e), e, new_paths} | acc]

          true ->
            acc
        end
      end)
      |> Enum.sort()

    shortest_path(world, visited, queue, max_cost)
  end

  # @spec shortest_path(
  #         graph(),
  #         %{pos() => {cost(), pathlist()}},
  #         [{cost(), pos(), pathlist()}],
  #         cost()
  #       ) :: %{pos() => {non_neg_integer(), pathlist()}}
  @doc """
    Find all shortest paths that `max_cost` allows for

    If `max_cost` is `:infinity`, then just the first shortest path will be found.
  """
  def shortest_path(world, visited, queue, max_cost)
  def shortest_path(_, visited, [], _), do: visited

  def shortest_path(world, visited, [{cost, pos, paths} | queue], max_cost) do
    {previous_cost, previous_paths} = Map.get(visited, pos, {:infinity, [[]]})

    cond do
      max_cost == :inifinity && previous_cost != :infinity ->
        shortest_path(world, visited, queue, max_cost)

      cost > max_cost ->
        shortest_path(world, visited, queue, max_cost)

      true ->
        cond do
          previous_cost > cost ->
            ps = prepend_to_paths(paths, pos)

            continue_shortest_path(
              world,
              Map.put(visited, pos, {cost, ps}),
              queue,
              pos,
              cost,
              ps,
              max_cost
            )

          previous_cost == cost ->
            ps = prepend_to_paths(Enum.concat(paths, previous_paths), pos)

            shortest_path(
              world,
              Map.put(visited, pos, {cost, ps}),
              queue,
              max_cost
            )

          previous_cost < cost ->
            {visited, previous_paths}
            shortest_path(world, visited, queue, max_cost)
        end
    end
  end

  defp find_start(world) do
    {k, _} = Enum.find(world, fn {_, v} -> v == "S" end)
    k
  end

  defp find_goal(world) do
    {k, _} = Enum.find(world, fn {_, v} -> v == "E" end)
    k
  end

  @doc """
    Find the length of the shortest path from start to goal
  """
  def part_one(input) do
    world = input |> Types.matrix_to_tuple_matrix()
    start = find_start(world)
    goal = find_goal(world)

    res = shortest_path(world, %{}, [{0, {start, @east}, []}], :infinity)

    [
      res |> Map.get({goal, @east}),
      res |> Map.get({goal, @west}),
      res |> Map.get({goal, @north}),
      res |> Map.get({goal, @south})
    ]
    |> Enum.reject(&(&1 == nil))
    |> Enum.min()
    |> elem(0)
  end

  @doc """
    Count the number of unique nodes along all shortest paths
  """
  def part_two(input) do
    min_cost = part_one(input)
    world = input |> Types.matrix_to_tuple_matrix()
    start = find_start(world)
    goal = find_goal(world)

    res = shortest_path(world, %{}, [{0, {start, @east}, [[]]}], min_cost)

    [
      res |> Map.get({goal, @east}),
      res |> Map.get({goal, @west}),
      res |> Map.get({goal, @north}),
      res |> Map.get({goal, @south})
    ]
    |> Enum.reject(&(&1 == nil))
    |> Enum.filter(fn {cost, _} -> cost == min_cost end)
    |> Enum.reduce([], fn {_, paths}, acc ->
      Enum.concat(paths) |> Enum.concat(acc)
    end)
    |> Enum.uniq()
    |> build_paths(MapSet.new(), res, MapSet.new())
    |> MapSet.size()
  end

  @spec build_paths(
          [pos()],
          MapSet.t(pos()),
          %{pos() => {cost(), pathlist()}},
          MapSet.t(vertex())
        ) :: MapSet.t(vertex())
  defp build_paths(paths, seen, shortest_paths, acc)
  defp build_paths([], _, _, acc), do: acc

  defp build_paths([node = {pos, _} | paths], seen, shortest_paths, acc) do
    if MapSet.member?(seen, node) do
      build_paths(paths, seen, shortest_paths, acc)
    else
      seen = MapSet.put(seen, node)
      acc = MapSet.put(acc, pos)

      case Map.get(shortest_paths, node, nil) do
        nil ->
          build_paths(paths, seen, shortest_paths, acc)

        {_, some} ->
          if MapSet.member?(seen, some) do
            build_paths(paths, seen, shortest_paths, acc)
          else
            paths = Enum.concat(Enum.concat(some), paths)
            build_paths(paths, seen, shortest_paths, acc)
          end
      end
    end
  end
end

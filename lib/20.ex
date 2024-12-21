defmodule AdventOfCode.Twenty do
  @moduledoc false

  @typep world :: Types.tuple_matrix(String.t())
  @typep position :: {non_neg_integer(), non_neg_integer()}

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_matrix(20) |> part_one(100) |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_matrix(20) |> part_two(100) |> IO.puts()
  end

  defp find_index(matrix, target) do
    {idx, _} = matrix |> Enum.find(fn {_, v} -> v == target end)
    idx
  end

  defp neighbors({i, j}) do
    [
      {i + 1, j},
      {i - 1, j},
      {i, j + 1},
      {i, j - 1}
    ]
  end

  defp explore_neighbors(pos, world, queue, visited, path, cost) do
    neighbors(pos)
    |> Enum.reduce(queue, fn e, acc ->
      cond do
        Map.has_key?(visited, e) ->
          acc

        Map.get(world, e) == "#" ->
          acc

        Map.has_key?(world, e) ->
          [{cost + 1, e, [pos | path]} | acc]

        true ->
          acc
      end
    end)
  end

  @spec shortest_path(
          world(),
          position(),
          %{position() => non_neg_integer()},
          [{non_neg_integer(), position(), [position()]}]
        ) :: %{position() => non_neg_integer}
  @doc """
    Find all shortest paths that `max_cost` allows for

    If `max_cost` is `:infinity`, then just the first shortest path will be found.
  """
  def shortest_path(world, goal, visited, queue)
  def shortest_path(_, _, visited, []), do: visited

  def shortest_path(_, goal, visited, [{cost, pos, path} | _])
      when pos == goal do
    Map.put(visited, pos, {cost, path})
  end

  def shortest_path(world, goal, visited, [{cost, pos, path} | queue]) do
    {previous_cost, _} = Map.get(visited, pos, {:infinity, []})

    if previous_cost != :infinity do
      shortest_path(world, goal, visited, queue)
    else
      visited =
        if previous_cost > cost do
          Map.put(visited, pos, {cost, path})
        else
          visited
        end

      queue =
        explore_neighbors(pos, world, queue, visited, path, cost)
        |> Enum.sort()

      shortest_path(world, goal, visited, queue)
    end
  end

  defp manhattan_dis({fi, fj}, {ti, tj}) do
    abs(ti - fi) + abs(tj - fj)
  end

  defp dist(from, to, distance_start, distance_goal) do
    distance_goal + distance_start + manhattan_dis(from, to)
  end

  defp cheat_goals({x, y}, limit, cost_limit, world) do
    for i <- 0..limit do
      for j <- 0..(limit - i) do
        [{x + i, y + j}, {x - i, y + j}, {x + i, y - j}, {x - i, y - j}]
      end
      |> Enum.concat()
    end
    |> Enum.concat()
    |> Enum.uniq()
    |> Enum.filter(fn cheat_goal ->
      dis = manhattan_dis({x, y}, cheat_goal)

      dis > 0 && dis <= cost_limit && {x, y} != cheat_goal &&
        Map.get(world, cheat_goal, "#") != "#"
    end)
  end

  defp cheat([], seen, _, _, _, _, _, _), do: seen

  defp cheat(
         [pos | path],
         seen,
         world,
         distances,
         d_goal,
         cheat_size,
         min_time,
         limit
       ) do
    neighbors = cheat_goals(pos, cheat_size, limit, world)

    seen =
      neighbors
      |> Enum.reduce(seen, fn e, acc ->
        {d_start, _} = Map.get(distances, e)
        cost = dist(pos, e, min_time - d_start, d_goal)
        key = {pos, e}
        Map.update(acc, key, cost, fn c -> min(c, cost) end)
      end)

    Progress.add_done()
    cheat(path, seen, world, distances, d_goal + 1, cheat_size, min_time, limit)
  end

  defp run(input, limit, cheat_size) do
    Progress.init()
    world = input |> Types.matrix_to_tuple_matrix()
    start = find_index(world, "S")
    goal = find_index(world, "E")

    res = shortest_path(world, goal, %{}, [{0, start, []}])
    {min_time, path} = res |> Map.get(goal)

    path = path |> Enum.reverse()
    Progress.add_total(min_time)

    cheat(path, %{}, world, res, 0, cheat_size, min_time, limit)
    |> Map.values()
    |> Enum.map(&(min_time - &1))
    |> Enum.count(&(&1 >= limit))
    |> Progress.stop()
  end

  @doc """
    Count how many 2-step cheats safe more than 100 ms
  """
  def part_one(input, limit) do
    run(input, limit, 2)
  end

  @doc """
    Count how many 20-step cheats safe more than 100 ms
  """
  def part_two(input, limit) do
    run(input, limit, 20)
  end
end

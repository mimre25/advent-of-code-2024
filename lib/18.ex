defmodule AdventOfCode.Eighteen do
  @moduledoc false

  @typep world :: Types.tuple_matrix(non_neg_integer())
  @typep position :: {non_neg_integer(), non_neg_integer()}
  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(18) |> part_one(70, 70, 1024) |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(18) |> part_two(70, 70, 1024) |> IO.puts()
  end

  defp neighbors({i, j}) do
    [
      {i + 1, j},
      {i - 1, j},
      {i, j + 1},
      {i, j - 1}
    ]
  end

  defp update_visited(visited, pos, previous_cost, cost) do
    if previous_cost > cost do
      Map.put(visited, pos, cost)
    else
      visited
    end
  end

  defp update_queue(world, queue, pos, visited, cost, num_bytes) do
    neighbors(pos)
    |> Enum.reduce(queue, fn e, acc ->
      cond do
        Map.has_key?(visited, e) -> acc
        Map.get(world, e) <= num_bytes -> acc
        Map.has_key?(world, e) -> [{cost + 1, e} | acc]
        true -> acc
      end
    end)
    |> Enum.sort()
  end

  @spec shortest_path(
          world(),
          position(),
          %{position() => non_neg_integer()},
          [{non_neg_integer(), position()}],
          non_neg_integer()
        ) :: %{position() => non_neg_integer}
  @doc """
    Find the shortest path possible after num_bytes have fallen
  """
  def shortest_path(_, _, visited, [], _), do: visited

  def shortest_path(world, goal, visited, [{cost, pos} | queue], num_bytes) do
    previous_cost = Map.get(visited, pos, :infinity)

    cond do
      previous_cost != :infinity ->
        shortest_path(world, goal, visited, queue, num_bytes)

      Map.get(world, pos) <= cost ->
        shortest_path(world, goal, visited, queue, num_bytes)

      true ->
        visited = update_visited(visited, pos, previous_cost, cost)

        queue = update_queue(world, queue, pos, visited, cost, num_bytes)

        shortest_path(world, goal, visited, queue, num_bytes)
    end
  end

  @spec build_world(
          [String.t()],
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer()
        ) :: world()
  defp build_world(input, w, h, num_bytes) do
    map =
      for i <- 0..h, j <- 0..w do
        {{j, i}, :infinity}
      end
      |> Map.new()

    input
    |> Enum.reject(&(&1 == "\n"))
    # only take fisrt kilobyte
    |> Enum.take(num_bytes)
    |> Enum.with_index()
    |> Enum.reduce(map, fn {line, n}, acc ->
      [x, y] =
        String.split(line, ~r/,|\n/, trim: true)
        |> Enum.map(&String.to_integer/1)

      Map.put(acc, {y, x}, n + 1)
    end)
    |> Map.new()
  end

  @doc """
    Find the lenght of the shortest path after `num_bytes` bytes have fallen
  """
  def part_one(input, w, h, num_bytes) do
    world = build_world(input, h, w, num_bytes)

    start = {0, 0}
    goal = {w, h}

    shortest_path(world, goal, %{}, [{0, start}], num_bytes) |> Map.get(goal)
  end

  @spec find_unreachable(
          [String.t()],
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer()
        ) :: non_neg_integer()
  @doc """
    Binary search to find when the goal isn't reachable anymore
  """
  def find_unreachable(_, _, _, min_bytes, max_bytes)
      when min_bytes == max_bytes,
      do: min_bytes

  def find_unreachable(_, _, _, min_bytes, max_bytes)
      when min_bytes == max_bytes + 1,
      do: min_bytes

  def find_unreachable(_, _, _, min_bytes, max_bytes)
      when min_bytes == max_bytes - 1,
      do: min_bytes

  def find_unreachable(input, h, w, min_bytes, max_bytes) do
    num_bytes = div(min_bytes + max_bytes, 2)

    world = build_world(input, h, w, num_bytes)
    start = {0, 0}
    goal = {w, h}

    res =
      shortest_path(world, goal, %{}, [{0, start}], num_bytes) |> Map.get(goal)

    if res == nil do
      # unreachable
      find_unreachable(input, h, w, min_bytes, num_bytes)
    else
      # reachable
      find_unreachable(input, h, w, num_bytes, max_bytes)
    end
  end

  @doc """
    Find the location of the first byte that, when it falls, makes the goal unreachable
  """
  def part_two(input, w, h, start_bytes) do
    total_bytes = Enum.count(input)

    idx = find_unreachable(input, h, w, start_bytes, total_bytes)

    Enum.at(input, idx) |> String.replace(~r/\n/, "")
  end
end

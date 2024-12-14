defmodule AdventOfCode.Fourteen do
  @moduledoc false

  @typep boundary :: {non_neg_integer(), non_neg_integer()}
  @typep position :: {non_neg_integer(), non_neg_integer()}
  @typep velocity :: {integer(), integer()}
  @typep robot :: {position(), velocity()}

  @doc false
  def main() do
    IO.puts("Part one:")

    Input.read_file_into_list(14)
    |> part_one(height: 103, width: 101)
    |> IO.puts()

    IO.puts("Part two:")
    Input.read_file_into_list(14) |> part_two(height: 103, width: 101)
  end

  @spec parse_robot(String.t()) :: robot()
  def parse_robot(s) do
    # p=0,4 v=3,-3 -> {{0,4}, {3, -3}}
    [_, px, py, vx, vy] = Regex.run(~r/p=(\d+),(\d+) v=(-?\d+),(-?\d+)/, s)

    {{String.to_integer(px), String.to_integer(py)},
     {String.to_integer(vx), String.to_integer(vy)}}
  end

  @spec simulate_robot_step(robot(), boundary(), non_neg_integer()) :: robot()
  def simulate_robot_step({{px, py}, {vx, vy}}, {height, width}, steps) do
    {{Integer.mod(px + vx * steps, width),
      Integer.mod(py + vy * steps, height)}, {vx, vy}}
  end

  @spec simulate_robots([robot()], non_neg_integer(), boundary()) :: [robot()]
  def simulate_robots(robots, steps, step_size \\ 1, boundary, save \\ false)
  def simulate_robots(robots, 0, _, _, _), do: robots

  def simulate_robots(robots, steps, step_size, boundary, save) do
    robots
    |> Enum.map(fn r -> simulate_robot_step(r, boundary, step_size) end)
    |> tap(fn r ->
      Progress.add_done()

      if save do
        write_robots_to_file(r, boundary, steps)
      end
    end)
    |> simulate_robots(steps - 1, step_size, boundary, save)
  end

  @spec quadrant_size(boundary()) :: boundary()
  defp quadrant_size({height, width}) do
    qh = div(height - 1, 2)
    qw = div(width - 1, 2)
    {qh, qw}
  end

  @spec quadrant_num(robot(), boundary()) :: nil | 1 | 2 | 3 | 4
  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  def quadrant_num({{px, py}, _}, {qh, qw}) do
    cond do
      px == qw || py == qh -> nil
      px < qw && py < qh -> 1
      px > qw && py < qh -> 2
      px < qw && py > qh -> 3
      px > qw && py > qh -> 4
    end
  end

  @doc """
    Simulate the robots for 100 seconds and compute the safety factor
  """
  def part_one(input, [{:height, height}, {:width, width}]) do
    Progress.init()
    Progress.add_total(100)
    qsize = quadrant_size({height, width})

    res =
      input
      |> Enum.filter(&(&1 != "\n"))
      |> Enum.map(&parse_robot/1)
      |> simulate_robots(100, {height, width})
      |> Enum.map(fn r ->
        quadrant_num(r, qsize)
      end)
      |> Enum.filter(&Function.identity/1)
      |> Enum.group_by(&Function.identity/1)
      |> Enum.map(fn {_, rs} -> Enum.count(rs) end)
      |> Enum.product()

    Progress.stop()
    res
  end

  @spec write_robots_to_file([robot()], boundary(), String.t()) :: nil
  defp write_robots_to_file(robots, {height, width}, file_name) do
    field =
      for i <- 0..(height - 1), j <- 0..(width - 1) do
        {{i, j}, "."}
      end
      |> Map.new()

    {content, _} =
      robots
      |> Enum.reduce(field, fn {{x, y}, _}, acc ->
        Map.put(acc, {y, x}, "r")
      end)
      |> Enum.sort()
      |> Enum.reduce({"", 0}, fn {{y, _}, c}, {acc, prev_y} ->
        if y != prev_y do
          {acc <> "\n" <> c, y}
        else
          {acc <> c, y}
        end
      end)

    # No matter how a christmas tree looks like, it gotta have a straight line somewhere
    if Regex.match?(~r/rrrrrrrrr/, content) do
      File.write!("pics/14/#{file_name}", content)
    end

    nil
  end

  @doc """
    Find the first iteration in which the robots resemble a christmas tree
  """
  def part_two(input, [{:height, height}, {:width, width}]) do
    Progress.init()
    Progress.add_total(10_000)

    input
    |> Enum.filter(&(&1 != "\n"))
    |> Enum.map(&parse_robot/1)
    |> simulate_robots(10_000, 1, {height, width}, true)

    Progress.stop()
  end
end

defmodule AdventOfCode.Twelve do
  @moduledoc false

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_matrix(12) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_matrix(12) |> part_two() |> IO.puts()
  end

  defp build_region(map, i, j, plant, region, regions, mem) do
    if Map.get(mem, {i, j}) != nil do
      {regions, mem}
    else
      if map[i][j] == plant do
        m = Map.put(mem, {i, j}, plant)
        r = Map.update(regions, region, [{i, j}], fn x -> [{i, j} | x] end)
        {r, m} = build_region(map, i - 1, j, plant, region, r, m)
        {r, m} = build_region(map, i + 1, j, plant, region, r, m)
        {r, m} = build_region(map, i, j - 1, plant, region, r, m)
        build_region(map, i, j + 1, plant, region, r, m)
      else
        {regions, mem}
      end
    end
  end

  defp find_regions(map) do
    map
    |> Enum.reduce({%{}, %{}, 0}, fn {i, row}, {regions, mem, rn} ->
      Enum.reduce(row, {regions, mem, rn}, fn {j, plant}, {r, m, region_num} ->
        {res_reg, res_mem} = build_region(map, i, j, plant, region_num, r, m)
        {res_reg, res_mem, region_num + 1}
      end)
    end)
  end

  defp compute_area(regions) do
    Enum.map(regions, fn {r_num, region} -> {r_num, Enum.count(region)} end)
  end

  defp compute_fence(map, i, j) do
    [
      map[i + 1][j],
      map[i - 1][j],
      map[i][j + 1],
      map[i][j - 1]
    ]
    |> Enum.map(fn e -> (e == map[i][j] && 0) || 1 end)
    |> Enum.sum()
  end

  defp compute_fences(map, regions) do
    Enum.map(regions, fn {r_num, region} ->
      res =
        Enum.reduce(region, 0, fn {i, j}, acc ->
          acc + compute_fence(map, i, j)
        end)

      {r_num, res}
    end)
  end

  @doc """
    Compute the fence costs by area * #fences
  """
  def part_one(input) do
    {regions, _, _} = input |> find_regions()
    areas = compute_area(regions)
    fences = compute_fences(input, regions)

    Enum.zip_with(
      [areas, fences],
      fn [{r1, a}, {r2, f}] ->
        if r1 != r2 do
          IO.puts("order is wrong #{r1}, #{r2}")
        end

        a * f
      end
    )
    |> Enum.sum()
  end

  defp get_neighbors({i, j}, map) do
    [
      map[{i + 1, j}],
      map[{i - 1, j}],
      map[{i, j + 1}],
      map[{i, j - 1}]
    ]
    |> Enum.filter(&Function.identity/1)
  end

  defp missing_neighbor(nil, _, _, _), do: 1
  defp missing_neighbor(_, nil, _, _), do: 2
  defp missing_neighbor(_, _, nil, _), do: 3
  defp missing_neighbor(_, _, _, nil), do: 4

  defp corner(map, _, [{i1, _}, {i2, _}, {_, j3}, {_, j4}]) do
    Enum.count(
      [
        map[{i1, j4}],
        map[{i1, j3}],
        map[{i2, j4}],
        map[{i2, j3}]
      ],
      fn x -> x == nil end
    )
  end

  defp corner(map, {i, j}, [{i1, _}, {i2, j2}, {_, j3}]) do
    [n1, n2, n3, n4] = [
      map[{i + 1, j}],
      map[{i - 1, j}],
      map[{i, j + 1}],
      map[{i, j - 1}]
    ]

    case missing_neighbor(n1, n2, n3, n4) do
      1 -> [map[{i1, j2}], map[{i1, j3}]]
      2 -> [map[{i1, j2}], map[{i1, j3}]]
      3 -> [map[{i1, j3}], map[{i2, j3}]]
      4 -> [map[{i1, j3}], map[{i2, j3}]]
    end
    |> Enum.count(fn x -> x == nil end)
  end

  defp corner(map, _, [{i1, j1}, {i2, j2}]) do
    if i1 == i2 or j1 == j2 do
      0
    else
      if map[{i1, j2}] do
        1
      else
        2
      end
    end
  end

  defp compute_corner(map, pos, neighbors) do
    case Enum.count(neighbors) do
      0 -> 4
      1 -> 2
      2 -> corner(map, pos, neighbors)
      3 -> corner(map, pos, neighbors)
      4 -> corner(map, pos, neighbors)
    end
  end

  defp count_corners(region) do
    reg = Map.new(region, fn {x, y} -> {{x, y}, {x, y}} end)

    region
    |> Enum.reduce(0, fn pos, acc ->
      neighors = get_neighbors(pos, reg)
      compute_corner(reg, pos, neighors) + acc
    end)
  end

  defp compute_sides(regions) do
    Enum.map(regions, fn {rn, r} ->
      {rn, count_corners(r)}
    end)
  end

  @doc """
    Compute the fence cost by area * #sides
  """
  def part_two(input) do
    {regions, _, _} = input |> find_regions()
    areas = compute_area(regions)
    sides = compute_sides(regions)

    Enum.zip_with(
      [areas, sides],
      fn [{r1, a}, {r2, f}] ->
        if r1 != r2 do
          IO.puts("order is wrong #{r1}, #{r2}")
        end

        a * f
      end
    )
    |> Enum.sum()
  end
end

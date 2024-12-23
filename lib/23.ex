defmodule AdventOfCode.TwentyThree do
  @moduledoc false
  @typep vertex :: String.t()
  @typep edges :: [vertex()]
  @typep graph :: %{vertex() => edges()}
  @typep triplet(t) :: {t, t, t}
  @typep clique :: {non_neg_integer(), [vertex()]}

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(23) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(23) |> part_two() |> IO.puts()
  end

  @spec build_candidates(graph(), vertex(), edges()) :: [triplet(vertex())]
  defp build_candidates(graph, vertex, edges) do
    neighbors = edges

    edges
    |> Enum.map(fn v ->
      neighbors2 = Map.get(graph, v, MapSet.new())
      {v, MapSet.intersection(neighbors, neighbors2)}
    end)
    |> Enum.reject(fn {_, e} -> MapSet.size(e) == 0 end)
    |> Enum.flat_map(fn {v, ns} ->
      Enum.map(ns, fn n -> Enum.sort([vertex, v, n]) |> List.to_tuple() end)
    end)
  end

  @spec build_graph([vertex()]) :: graph()
  defp build_graph(input) do
    input
    |> Enum.reduce(%{}, fn [v1, v2], acc ->
      acc
      |> Map.update(v1, MapSet.new([v2]), fn edges ->
        MapSet.put(edges, v2)
      end)
      |> Map.update(v2, MapSet.new([v1]), fn edges ->
        MapSet.put(edges, v1)
      end)
    end)
  end

  defp t_vertex?(vertex), do: String.starts_with?(vertex, "t")
  defp edge?(graph, n1, n2), do: MapSet.member?(graph[n1], n2)

  @spec validate_candidates([triplet(vertex())], graph()) :: [triplet(vertex())]
  defp validate_candidates(candidates, graph) do
    candidates
    |> Enum.filter(fn {n1, n2, n3} ->
      (t_vertex?(n1) || t_vertex?(n2) || t_vertex?(n3)) &&
        edge?(graph, n1, n2) && edge?(graph, n2, n3) && edge?(graph, n3, n1)
    end)
  end

  @doc """
    Find the number of 3-cliques in the graph
  """
  def part_one(input) do
    graph =
      input
      |> Enum.reject(&(&1 == "\n"))
      |> Enum.map(fn l -> String.split(l, ~r/-|\n/, trim: true) end)
      |> build_graph()
      # no need to keep vertices with just one edge
      |> Map.filter(fn {_, e} -> Enum.count(e) >= 2 end)

    graph
    |> Enum.sort()
    |> Enum.map(fn {v, edges} -> build_candidates(graph, v, edges) end)
    |> Enum.concat()
    |> Enum.uniq()
    |> Enum.sort()
    |> validate_candidates(graph)
    |> Enum.count()
  end

  @spec build_new_cliques(graph(), [vertex()], MapSet.t([vertex()])) :: [
          clique()
        ]
  defp build_new_cliques(graph, clique, seen) do
    clique
    |> Enum.map(&graph[&1])
    |> Enum.reduce(fn edges, acc ->
      MapSet.intersection(edges, acc)
    end)
    |> Enum.reduce([], fn vertex, acc ->
      new_clique = Enum.sort([vertex | clique])

      if clique?(new_clique, graph) && !MapSet.member?(seen, new_clique) do
        [{Enum.count(new_clique), new_clique} | acc]
      else
        acc
      end
    end)
  end

  @spec find_largest_clique(graph(), [clique()], clique(), MapSet.t([vertex()])) ::
          clique()
  defp find_largest_clique(_, [], {_, biggest_clique}, _), do: biggest_clique

  defp find_largest_clique(
         graph,
         [{_, clique} | cliques],
         acc = {biggest_size, biggest_clique},
         seen
       ) do
    clique = Enum.sort(clique)

    if MapSet.member?(seen, clique) do
      find_largest_clique(graph, cliques, acc, seen)
    else
      seen = MapSet.put(seen, clique)

      new_cliques = build_new_cliques(graph, clique, seen)

      Progress.add_total(Enum.count(new_cliques))

      acc =
        case Enum.count(new_cliques) do
          0 -> {biggest_size, biggest_clique}
          _ -> max(acc, Enum.max(new_cliques))
        end

      new_cliques = Enum.concat(new_cliques, cliques)

      Progress.add_done()
      find_largest_clique(graph, new_cliques, acc, seen)
    end
  end

  defp clique_reducer({[], _, _}, acc), do: acc
  defp clique_reducer(_, false), do: false

  defp clique_reducer({[vertex | rem], vertices, graph}, _) do
    edges = MapSet.put(graph[vertex], vertex)
    acc = MapSet.subset?(vertices, MapSet.intersection(edges, vertices))
    clique_reducer({rem, vertices, graph}, acc)
  end

  @spec clique?([vertex()], graph()) :: boolean()
  defp clique?(vertices, graph) do
    clique_reducer({vertices, MapSet.new(vertices), graph}, true)
  end

  @doc """
    Find the largest clique in the graph
  """
  def part_two(input) do
    graph =
      input
      |> Enum.reject(&(&1 == "\n"))
      |> Enum.map(fn l -> String.split(l, ~r/-|\n/, trim: true) end)
      |> build_graph()
      # no need to keep vertices with just one edge (since we know there is at least a 3-clique
      |> Map.filter(fn {_, e} -> Enum.count(e) >= 2 end)

    three_cliques =
      graph
      |> Enum.sort()
      |> Enum.map(fn {v, edges} -> build_candidates(graph, v, edges) end)
      |> Enum.concat()
      |> Enum.uniq()
      |> Enum.sort()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.filter(fn vertices -> clique?(vertices, graph) end)
      |> Enum.map(&{3, &1})

    Progress.init()
    Progress.add_total(Enum.count(three_cliques))

    find_largest_clique(
      graph,
      three_cliques,
      Enum.at(three_cliques, 0),
      MapSet.new()
    )
    |> Enum.sort()
    |> Enum.join(",")
  end
end

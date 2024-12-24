defmodule AdventOfCode.TwentyFour do
  @moduledoc false

  @typep op :: (boolean(), boolean() -> boolean()) | String.t()
  @typep gate :: String.t()
  @typep dependency :: {gate(), gate(), op()}
  @typep wire :: {gate(), boolean()}

  @b45 0b111111111111111111111111111111111111111111111

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(24) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(24) |> part_two() |> IO.puts()
  end

  defp to_bool("0"), do: false
  defp to_bool("1"), do: true

  defp parse_op("AND"), do: &and/2
  defp parse_op("OR"), do: &or/2

  defp parse_op("XOR") do
    fn l, r ->
      (l and !r) or (!l and r)
    end
  end

  defp parse_wire(wire) do
    [name, val] = String.split(wire, ~r/:|\n| /, trim: true)
    {name, to_bool(val)}
  end

  defp parse_gate(gate, raw) do
    [in1, op, in2, out] = String.split(gate, ~r/ |->|\n/, trim: true)

    if raw do
      {in1, in2, out, op}
    else
      {in1, in2, out, parse_op(op)}
    end
  end

  defp parse(input, raw \\ false) do
    wires =
      input
      |> Enum.take_while(&(&1 != "\n"))
      |> Enum.map(&parse_wire/1)
      |> Map.new()

    gates =
      input
      |> Enum.drop_while(&(&1 != "\n"))
      |> Enum.reject(&(&1 == "\n"))
      |> Enum.map(&parse_gate(&1, raw))

    {wires, gates}
  end

  @spec build_depdency_graph([{node(), node(), node(), op()}]) ::
          {%{
             gate() => dependency()
           }, %{gate() => [gate()]}}
  defp build_depdency_graph(gates) do
    gates
    |> Enum.reduce({%{}, %{}}, fn {in1, in2, out, op}, {deps, rev_deps} ->
      rev_deps = Map.update(rev_deps, in1, [out], fn e -> [out | e] end)
      rev_deps = Map.update(rev_deps, in2, [out], fn e -> [out | e] end)
      {Map.put(deps, out, {in1, in2, op}), rev_deps}
    end)
  end

  defp ready?(in1, in2, ready) do
    Map.get(ready, in1) != nil && Map.get(ready, in2) != nil
  end

  defp evaluate_step(todo = {out, {in1, in2, op}}, {done, new_todos}) do
    if ready?(in1, in2, done) do
      res = op.(Map.get(done, in1), Map.get(done, in2))
      {Map.put(done, out, res), new_todos}
    else
      {done, [todo | new_todos]}
    end
  end

  @spec evaluate_circuit(
          %{gate() => boolean()},
          %{gate() => dependency()},
          [{gate(), dependency()}]
        ) ::
          %{gate() => boolean()}
  defp evaluate_circuit(ready, deps, todos)
  defp evaluate_circuit(ready, _, []), do: ready

  defp evaluate_circuit(ready, deps, todos) do
    {updated_ready, updated_todos} =
      todos
      |> Enum.reduce({ready, []}, fn x1, x2 ->
        evaluate_step(x1, x2)
      end)

    if Enum.count(Map.to_list(updated_ready) -- Map.to_list(ready)) > 0 do
      evaluate_circuit(updated_ready, deps, updated_todos)
    else
      %{}
    end
  end

  @spec wire_value(wire(), String.t()) :: non_neg_integer()
  defp wire_value({name, value}, letter \\ "z") do
    if String.starts_with?(name, letter) do
      wire_number = String.replace(name, letter, "") |> String.to_integer()

      if value do
        Integer.pow(2, wire_number)
      else
        0
      end
    else
      0
    end
  end

  @doc """
    Compute the output of the logical circuit and convert z-wires into an integer
  """
  def part_one(input) do
    {inputs, gates} = parse(input)
    {deps, _} = build_depdency_graph(gates)

    evaluate_circuit(inputs, deps, Map.to_list(deps))
    |> Enum.reduce(0, fn wire, acc -> acc + wire_value(wire) end)
  end

  defp gate_shape("AND"), do: "invtriangle"
  defp gate_shape("XOR"), do: "diamond"
  defp gate_shape("OR"), do: "hexagon"
  defp gate_shape(nil), do: "circle"

  @doc false
  def draw_graph(deps) do
    {edges, gatemap} =
      deps
      |> Enum.reduce({[], %{}}, fn {out, {in1, in2, op}}, {es, ns} ->
        ns = Map.update(ns, out, op, fn _ -> op end)
        ns = Map.update(ns, in1, nil, &Function.identity/1)
        ns = Map.update(ns, in2, nil, &Function.identity/1)
        es = ["#{in1} -> #{out}" | es]
        es = ["#{in2} -> #{out}" | es]
        {es, ns}
      end)

    gates =
      gatemap
      |> Enum.map(fn {n, v} ->
        "#{n} [label=\"#{n}\" shape=#{gate_shape(v)}]"
      end)

    lines =
      Enum.concat([
        ["digraph G {"],
        gates,
        edges,
        ["}"]
      ])

    File.write!("graph.dot", Enum.join(lines, "\n"))
  end

  defp diffing_bit_reducer(diff) do
    Integer.to_string(diff, 2)
    |> String.split("", trim: true)
    |> Enum.reverse()
    |> Enum.reduce_while(-1, fn
      "1", acc -> {:halt, acc + 1}
      "0", acc -> {:cont, acc + 1}
    end)
  end

  defp find_diffing_bit(fst, snd) do
    if fst != nil && snd != nil do
      # only take 45 bits as our adder only goes for 45 bits
      fst = Bitwise.&&&(fst, @b45)
      snd = Bitwise.&&&(snd, @b45)
      diff = Bitwise.bxor(fst, snd)

      if diff == 0 do
        nil
      else
        diffing_bit_reducer(diff)
      end
    end
  end

  defp all_pairs([], acc), do: acc

  defp all_pairs([e | rest], acc) do
    acc = rest |> Enum.map(&{e, &1}) |> Enum.concat(acc)
    all_pairs(rest, acc)
  end

  defp get_gates_for_bit(bit, deps, rev_deps) do
    pad = Integer.to_string(bit) |> String.pad_leading(2, "0")
    {z_dep1, z_dep2, _} = Map.get(deps, "z#{pad}")
    x_descendents = Map.get(rev_deps, "x#{pad}")
    y_descendents = Map.get(rev_deps, "y#{pad}")

    Enum.concat(x_descendents, y_descendents)
    |> Enum.flat_map(&[&1 | Map.get(rev_deps, &1, [])])
    |> Enum.concat([z_dep1, z_dep2, "z#{pad}"])
    |> Enum.reject(&(&1 == nil))
    |> Enum.uniq()
  end

  defp swap_wires(deps, {w1, w2}) do
    {w1_gate, deps} = Map.pop(deps, w1)
    {w2_gate, deps} = Map.pop(deps, w2)
    deps |> Map.put(w1, w2_gate) |> Map.put(w2, w1_gate)
  end

  defp fix(
         deps,
         rev_deps,
         input_wires,
         acc \\ [],
         previous_bit \\ -1,
         steps \\ 1
       ) do
    res =
      evaluate_circuit(input_wires, deps, Map.to_list(deps))
      |> Enum.reduce(0, fn wire, acc -> acc + wire_value(wire) end)

    x_val =
      input_wires
      |> Enum.reduce(0, fn wire, acc -> acc + wire_value(wire, "x") end)

    y_val =
      input_wires
      |> Enum.reduce(0, fn wire, acc -> acc + wire_value(wire, "y") end)

    sum = x_val + y_val

    first_diffing_bit =
      find_diffing_bit(res, sum)

    cond do
      first_diffing_bit == nil ->
        {acc |> Enum.sort(), previous_bit, deps}

      steps > 4 ->
        []

      first_diffing_bit <= previous_bit ->
        []

      true ->
        get_gates_for_bit(first_diffing_bit, deps, rev_deps)
        |> all_pairs([])
        |> tap(fn ls -> Enum.count(ls) end)
        |> Enum.reject(fn {g1, g2} ->
          Map.get(deps, g1) == nil || Map.get(deps, g2) == nil
        end)
        |> Enum.map(fn pair ->
          new_acc = Enum.concat(Tuple.to_list(pair), acc)

          updated_deps = swap_wires(deps, pair)

          fix(
            updated_deps,
            rev_deps,
            input_wires,
            new_acc,
            first_diffing_bit,
            steps + 1
          )
          |> List.wrap()
        end)
        |> Enum.reject(&(&1 == nil || &1 == []))
        |> Enum.concat()
    end
  end

  defp possible_inputs(max_bit) do
    all_options =
      for gate <- 0..max_bit, x <- [false, true], y <- [false, true] do
        padded_gate = String.pad_leading(Integer.to_string(gate), 2, "0")
        {{"x#{padded_gate}", x}, {"y#{padded_gate}", y}}
      end

    all_options
  end

  defp validate(deps, inputs, wires)
  defp validate(_, [], _), do: true

  defp validate(deps, [{{w1, i1}, {w2, i2}} | rest], wires) do
    input_wires = Map.put(wires, w1, i1)
    input_wires = Map.put(input_wires, w2, i2)

    res =
      evaluate_circuit(input_wires, deps, Map.to_list(deps))
      |> Enum.reduce(0, fn wire, acc -> acc + wire_value(wire, "z") end)

    x_val =
      input_wires
      |> Enum.reduce(0, fn wire, acc -> acc + wire_value(wire, "x") end)

    y_val =
      input_wires
      |> Enum.reduce(0, fn wire, acc -> acc + wire_value(wire, "y") end)

    sum = x_val + y_val

    case find_diffing_bit(res, sum) do
      nil -> validate(deps, rest, wires)
      _ -> false
    end
  end

  @doc """
    Find which wires have been swapped
  """
  def part_two(input) do
    {wires, gates} = parse(input)
    {deps, rev_deps} = build_depdency_graph(gates)

    possible_solutions =
      fix(deps, rev_deps, wires) |> Enum.reject(&(&1 == nil))

    max_bit =
      deps
      |> Enum.reduce(0, fn {gate, _}, acc ->
        case Integer.parse(gate) do
          :error -> acc
          {v, _} -> max(v, acc)
        end
      end)

    Progress.init()
    Progress.add_total(Enum.count(possible_solutions))

    {res, _} =
      possible_solutions
      |> Enum.map(fn {solution, _, solution_deps} ->
        possible_options = possible_inputs(max_bit)

        {solution, validate(solution_deps, possible_options, wires)}
        |> Progress.add_done()
      end)
      |> Enum.reject(&(&1 == nil))
      |> Enum.map(fn {x, y} -> {Enum.sort(x) |> Enum.join(","), y} end)
      |> Enum.filter(fn {_, x} -> x end)
      |> Enum.at(0)

    # swaps (computed manually with the graph)
    # res = [
    #   ["qwf", "cnk"],
    #   ["z14", "vhm"],
    #   ["z27", "mps"],
    #   ["z39", "msq"]
    # ]
    # res
    # |> Enum.concat()
    # |> Enum.sort()
    # |> Enum.join(",")
    res
  end
end

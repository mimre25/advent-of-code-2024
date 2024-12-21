defmodule AdventOfCode.TwentyOne do
  @moduledoc false

  @doc false
  def main() do
    Memoization.init()
    IO.puts("Part one:")
    Input.read_file_into_list(21) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(21) |> part_two() |> IO.puts()
    Memoization.stop()
  end

  defp numpad_mapping(0), do: 2
  defp numpad_mapping("A"), do: 3
  defp numpad_mapping(x), do: x + 3

  defp numpad_move(from, to)
  defp numpad_move(from, to) when from == to, do: ""

  defp numpad_move(from, to) when rem(from - 1, 3) > rem(to - 1, 3) do
    "<" <> numpad_move(from - 1, to)
  end

  defp numpad_move(from, to) when rem(from - 1, 3) < rem(to - 1, 3) do
    ">" <> numpad_move(from + 1, to)
  end

  defp numpad_move(from, to) when div(from + 2, 3) - div(to + 2, 3) >= 1 do
    "v" <> numpad_move(from - 3, to)
  end

  defp numpad_move(from, to) when div(from + 2, 3) - div(to + 2, 3) <= -1 do
    "^" <> numpad_move(from + 3, to)
  end

  defp try_to_int(v) do
    case Integer.parse(v) do
      {x, ""} -> x
      _ -> v
    end
  end

  @spec numpad(non_neg_integer() | String.t(), non_neg_integer()) ::
          [String.t()]
  @doc """
    Find the sequence of moves from `from` to `to` on the numpad below

    +---+---+---+
    | 7 | 8 | 9 |
    +---+---+---+
    | 4 | 5 | 6 |
    +---+---+---+
    | 1 | 2 | 3 |
    +---+---+---+
        | 0 | A |
        +---+---+
  """
  def numpad(to, from) do
    moves = numpad_move(numpad_mapping(from), numpad_mapping(to))

    all_posssible_moves =
      moves
      |> String.split("", trim: true)
      |> Permutations.permutate()
      |> Enum.uniq()
      |> Enum.map(fn e ->
        Enum.join(e) <> "A"
      end)
      |> Enum.reject(fn e -> invalid_sequence?(e, from, to, :numpad) end)

    if all_posssible_moves == [] do
      ["A"]
    else
      all_posssible_moves
    end
  end

  defp arrowpad_mapping("A"), do: 6
  defp arrowpad_mapping("^"), do: 5
  defp arrowpad_mapping("<"), do: 1
  defp arrowpad_mapping("v"), do: 2
  defp arrowpad_mapping(">"), do: 3

  @spec arrowpad(String.t(), String.t()) :: [String.t()]
  @doc """
    Find the sequence of moves from `from` to `to` on the arrowpad below
        +---+---+
        | ^ | A |
    +---+---+---+
    | < | v | > |
    +---+---+---+
  """
  def arrowpad(to, from) do
    moves = numpad_move(arrowpad_mapping(from), arrowpad_mapping(to))

    all_posssible_moves =
      moves
      |> String.split("", trim: true)
      |> Permutations.permutate()
      |> Enum.uniq()
      |> Enum.map(fn e ->
        Enum.join(e) <> "A"
      end)
      |> Enum.reject(fn e -> invalid_sequence?(e, from, to, :arrowpad) end)
      |> eliminiate_suboptimals()
      |> Enum.reject(&zigzag?/1)

    if all_posssible_moves == [] do
      ["A"]
    else
      all_posssible_moves
    end
  end

  def zigzag?(s) do
    Enum.any?([
      String.contains?(s, "<^<"),
      String.contains?(s, "<v<"),
      String.contains?(s, ">^>"),
      String.contains?(s, ">v>"),
      String.contains?(s, "^<^"),
      String.contains?(s, "^>^"),
      String.contains?(s, "v<v"),
      String.contains?(s, "v>v")
    ])
  end

  defp invalid_sequence?(sequence, from, to, :numpad) do
    case to do
      0 -> String.ends_with?(sequence, ">A")
      "A" -> String.ends_with?(sequence, ">>A")
      _ -> false
    end ||
      case from do
        0 -> String.starts_with?(sequence, "<")
        "A" -> String.starts_with?(sequence, "<<")
        _ -> false
      end
  end

  defp invalid_sequence?(sequence, from, to, :arrowpad) do
    case to do
      "^" -> String.ends_with?(sequence, ">A")
      "<" -> String.ends_with?(sequence, "vA")
      _ -> false
    end ||
      case from do
        "^" -> String.starts_with?(sequence, "<")
        "<" -> String.starts_with?(sequence, "^")
        _ -> false
      end
  end

  defp eliminiate_suboptimals([]), do: []

  defp eliminiate_suboptimals(sequences) do
    min_cost = sequences |> Enum.map(&String.length/1) |> Enum.min()
    sequences |> Enum.reject(&(String.length(&1) > min_cost))
  end

  defp run_pad(to, from, true) do
    numpad(try_to_int(to), try_to_int(from))
  end

  defp run_pad(to, from, false) do
    arrowpad(to, from)
  end

  @spec presses([String.t()], non_neg_integer(), boolean()) :: non_neg_integer()
  @doc """
    Compute the minimum number of presses for a given code and the amount of levels
  """
  def presses(code, level, first_level \\ false)
  def presses(code, 0, _), do: Enum.count(code)

  def presses(code, level, first_level) do
    key = {code, level}

    subpresses = fn sub_code, sub_presses ->
      presses = presses(sub_code, level - 1)
      [presses | sub_presses]
    end

    case Memoization.get(key) do
      nil ->
        code
        |> Enum.reduce({0, "A"}, fn next, {acc, prev} ->
          sub_presses =
            run_pad(next, prev, first_level)
            |> Enum.map(&String.split(&1, "", trim: true))
            |> Enum.reduce([], subpresses)

          {acc + Enum.min(sub_presses), next}
        end)
        |> then(fn {total, _} -> Memoization.update(key, total) end)

      some ->
        some
    end
  end

  @spec run([String.t()], non_neg_integer()) :: non_neg_integer()
  @doc """
    Calculate the sum of complexity of the given codes

    The complexity is given by the length of the code multiplied by its integer value.

    `n` defines how many levels deep the robots are nested.
  """
  def run(codes, n) do
    codes
    |> Enum.reduce(0, fn code, total ->
      presses = presses(String.split(code, "", trim: true), n, true)
      {val, _} = Integer.parse(code)
      total + presses * val
    end)
  end

  @doc """
    Compute how many button presses it takes to input the code for 3 levels of robots
  """
  def part_one(input) do
    sanitized_input =
      input |> Enum.map(fn s -> String.replace(s, ~r/\n/, "") end)

    sanitized_input |> run(3)
  end

  @doc """
    Compute how many button presses it takes to input the code for 26 levels of robots
  """
  def part_two(input) do
    sanitized_input =
      input |> Enum.map(fn s -> String.replace(s, ~r/\n/, "") end)

    sanitized_input |> run(26)
  end
end

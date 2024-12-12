defmodule AdventOfCode.Six do
  @moduledoc false

  @typep matrix :: Types.matrix(String.t())

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_matrix(6) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_matrix(6) |> part_two() |> IO.puts()
  end

  defp turn_right(field, i, j) do
    update_field(
      field,
      i,
      j,
      case field[i][j] do
        "^" -> ">"
        ">" -> "v"
        "<" -> "^"
        "v" -> "<"
      end
    )
  end

  @spec update_field(matrix(), non_neg_integer(), non_neg_integer(), String.t()) ::
          matrix()
  @doc """
    Update the field in a 2D matrix
  """
  def update_field(field, i, j, char) do
    Map.update!(field, i, fn row ->
      Map.update!(row, j, fn _ -> char end)
    end)
  end

  defp loop_updates(next_char, field, i, j) do
    case Integer.parse(next_char) do
      :error ->
        {false, field}

      {c_, _} ->
        c = Integer.to_string(c_ + 1)

        {true,
         case field[i][j] do
           "^" -> update_field(field, i - 1, j, c)
           ">" -> update_field(field, i, j + 1, c)
           "<" -> update_field(field, i, j - 1, c)
           "v" -> update_field(field, i + 1, j, c)
         end}
    end
  end

  @spec move(String.t(), matrix(), non_neg_integer(), non_neg_integer()) ::
          {boolean(), matrix()}
  @doc """
    Move the guard by one field

    This function also counts how often the guard bumps against an obstacle
    and returns either when the guard exits the field or runs into the same
    obstacle 4 times.

    If the guard exits the field {false, field} is returned, otherwise {true, field}
    to indiciate whther the guard runs in a loop or not.
  """
  def move(nil, field, i, j), do: {false, update_field(field, i, j, "X")}
  def move("4", field, i, j), do: {true, update_field(field, i, j, "X")}

  def move("#", field, i, j) do
    field_ =
      case field[i][j] do
        "^" -> update_field(field, i - 1, j, "0")
        ">" -> update_field(field, i, j + 1, "0")
        "<" -> update_field(field, i, j - 1, "0")
        "v" -> update_field(field, i + 1, j, "0")
      end

    updated_field = turn_right(field_, i, j)
    make_move(updated_field, i, j)
  end

  def move(next_char, field, i, j) do
    {obstacle, field_} = loop_updates(next_char, field, i, j)

    if obstacle do
      updated_field = turn_right(field_, i, j)
      make_move(updated_field, i, j)
    else
      current_pos = field[i][j]
      updated_field = update_field(field, i, j, "X")

      case current_pos do
        "^" -> make_move(update_field(updated_field, i - 1, j, "^"), i - 1, j)
        ">" -> make_move(update_field(updated_field, i, j + 1, ">"), i, j + 1)
        "<" -> make_move(update_field(updated_field, i, j - 1, "<"), i, j - 1)
        "v" -> make_move(update_field(updated_field, i + 1, j, "v"), i + 1, j)
      end
    end
  end

  @spec make_move(matrix(), non_neg_integer(), non_neg_integer()) ::
          {boolean(), matrix()}

  @doc """
    Corecursion to make moves
  """
  def make_move(field, i, j) do
    current_pos = field[i][j]

    case current_pos do
      "^" -> move(field[i - 1][j], field, i, j)
      ">" -> move(field[i][j + 1], field, i, j)
      "<" -> move(field[i][j - 1], field, i, j)
      "v" -> move(field[i + 1][j], field, i, j)
    end
  end

  defp find_guard_in_row(row) do
    Enum.find(row, {-1, -1}, fn {_key, value} ->
      Enum.member?(["^", ">", "<", "v"], value)
    end)
    |> elem(0)
  end

  defp find_guard_position_reducer({key, row}, {-1, -1}) do
    row_idx = find_guard_in_row(row)

    case row_idx do
      -1 -> {-1, -1}
      _ -> {key, row_idx}
    end
  end

  defp find_guard_position_reducer(_, acc) do
    acc
  end

  @spec find_guard_position(matrix()) :: {non_neg_integer(), non_neg_integer()}
  @doc """
    Find the position of the guard in the field
  """
  def find_guard_position(field) do
    Enum.to_list(field)
    |> Enum.reduce({-1, -1}, &find_guard_position_reducer/2)
  end

  @doc """
    Simulate the guard moving in the field
  """
  def simulate_guard(field) do
    {i, j} = field |> find_guard_position()
    make_move(field, i, j)
  end

  @doc """
    Count the number of fields a guard walks through
  """
  def part_one(input) do
    {_, resulting_field} = simulate_guard(input)

    Enum.reduce(resulting_field, 0, fn {_, row}, acc ->
      acc + Enum.count(row, fn {_, x} -> x == "X" end)
    end)
  end

  defp find_possible_obstacles_in_row(row, i, field) do
    Enum.reduce(row, 0, fn {j, c}, acc ->
      sum =
        acc +
          if Enum.member?(["^", "v", "<", ">", "#"], c) do
            0
          else
            {loop, _} = simulate_guard(update_field(field, i, j, "0"))
            (loop && 1) || 0
          end

      Progress.add_done()
      sum
    end)
  end

  defp find_possible_obstacle_places(field) do
    Progress.init()
    Progress.add_total(map_size(field) * map_size(field[0]))

    Enum.reduce(field, 0, fn {i, row}, outer_acc ->
      find_possible_obstacles_in_row(row, i, field) + outer_acc
    end)
  end

  @doc """
    Count the number of possible places for an obstacle that result in the guard looping
  """
  def part_two(input) do
    find_possible_obstacle_places(input)
  end
end

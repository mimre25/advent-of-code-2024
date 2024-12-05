defmodule AdventOfCode.Four do
  @moduledoc false
  @doc false
  def main() do
    IO.puts("Part one:")
    Input.get_input(4) |> Enum.join() |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_matrix(4) |> part_two() |> IO.puts()
  end

  @spec count_occurrences(String.t()) :: non_neg_integer()
  @doc """
    Counts how often the string XMAS appears in the given input.
  """
  def count_occurrences(str) do
    Regex.scan(~r/XMAS/, str) |> Enum.count()
  end

  @doc """
    Transpose a list of list of strings
  """
  def transpose_string_list(list) do
    list
    |> Enum.zip_with(&Function.identity/1)
    |> Enum.map(&Enum.join/1)
  end

  @spec transpose(String.t()) :: String.t()
  @doc """
    Transposes a multiline string
  """
  def transpose(str) do
    String.split(str, ~r/\n/, trim: true)
    |> Enum.map(fn s -> String.split(s, "") end)
    |> transpose_string_list()
    |> Enum.drop(1)
    |> Enum.join("\n")
  end

  @spec lshift(String.t(), non_neg_integer()) :: String.t()
  @doc """
    Shifts the string by the distance amount of characters to the left, padding with " ".
    For example
    iex> Four.lshift("abc", 1)
    "bc "
  """
  def lshift(str, distance) do
    String.slice(str, distance, 9_999_999) <> String.duplicate(" ", distance)
  end

  @spec lshift(String.t(), non_neg_integer()) :: String.t()
  @doc """
    Shifts the string by the distance amount of characters to the right, padding with " ".
    For example
    iex> Four.rshift("abc", 1)
    " ab"
  """
  def rshift(str, distance) do
    String.reverse(str) |> lshift(distance) |> String.reverse()
  end

  defp build_diagonal_from_matrix(matrix) do
    matrix
    |> Enum.map(fn s -> String.split(s, "", trim: true) end)
    |> transpose_string_list()
  end

  @spec build_diagonals(String.t()) :: [String.t()]
  @doc """
    Build a list containing all possible diagonals in the given multi-line string
  """
  def build_diagonals(input) do
    lines = String.split(input)
    reversed_lines = Enum.reverse(lines)

    # right-upper-triangle
    {pre_build, _} =
      Enum.map_reduce(lines, 0, fn l, acc ->
        {lshift(l, acc), acc + 1}
      end)

    right_upper_triangle = build_diagonal_from_matrix(pre_build)

    # left-upper-triangle
    {pre_build, _} =
      Enum.map_reduce(lines, 0, fn l, acc ->
        {rshift(l, acc), acc + 1}
      end)

    left_upper_triangle = build_diagonal_from_matrix(pre_build)

    # For the next two "triangles" we need to drop the last element as it's the main
    # diagonal of the matrix and already contained in the former two triangles
    # right-lower-triangle
    {pre_build, _} =
      Enum.map_reduce(reversed_lines, 0, fn l, acc ->
        {lshift(l, acc), acc + 1}
      end)

    right_lower_triangle = build_diagonal_from_matrix(pre_build) |> Enum.drop(1)
    # left-lower-triangle
    {pre_build, _} =
      Enum.map_reduce(reversed_lines, 0, fn l, acc ->
        {rshift(l, acc), acc + 1}
      end)

    left_lower_triangle = build_diagonal_from_matrix(pre_build) |> Enum.drop(-1)

    Enum.concat([
      right_upper_triangle,
      left_upper_triangle,
      right_lower_triangle,
      left_lower_triangle
    ])
  end

  @doc """
    Finds all occurrences of "XMAS" in a grid, allowing diagonals and all directions
  """
  def part_one(input) do
    transposed_input = transpose(input)

    diagonals = build_diagonals(input)

    rows_and_columns =
      [
        input,
        transposed_input
      ]
      |> Enum.map(fn x -> String.split(x, ~r/\n/) end)

    possible_directions = Enum.concat(Enum.concat(rows_and_columns), diagonals)

    Enum.reduce(possible_directions, 0, fn x, acc ->
      cnt = count_occurrences(x) + count_occurrences(String.reverse(x))
      acc + cnt
    end)
  end

  defp check_square(square) do
    fst_diagonal =
      case square[0][0] do
        "M" -> square[2][2] == "S"
        "S" -> square[2][2] == "M"
        _ -> false
      end

    snd_diagonal =
      case square[0][2] do
        "M" -> square[2][0] == "S"
        "S" -> square[2][0] == "M"
        _ -> false
      end

    fst_diagonal && snd_diagonal
  end

  defp check_position(i, j, matrix) do
    if matrix[i][j] == "A" do
      check_square(%{
        0 => %{
          0 => matrix[i - 1][j - 1],
          1 => matrix[i - 1][j],
          2 => matrix[i - 1][j + 1]
        },
        1 => %{0 => matrix[i][j - 1], 1 => matrix[i][j], 2 => matrix[i][j + 1]},
        2 => %{
          0 => matrix[i + 1][j - 1],
          1 => matrix[i + 1][j],
          2 => matrix[i + 1][j + 1]
        }
      })
    else
      false
    end
  end

  @doc """
    Find and count all the "MAS" corsses in an input grid
  """
  def part_two(matrix) do
    checks =
      for i <- 1..(map_size(matrix) - 2) do
        for j <- 1..(map_size(matrix[i]) - 2) do
          check_position(i, j, matrix)
        end
      end

    Enum.concat(checks) |> Enum.count(&Function.identity/1)
  end

  @doc """
    Parses the input given as string into a matrix and runs part_two/1
  """
  def part_two_str(input) do
    String.split(input, ~r/\n/)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Map.new()
    end)
    |> Enum.with_index(fn e, idx -> {idx, e} end)
    |> Map.new()
    |> part_two()
  end
end

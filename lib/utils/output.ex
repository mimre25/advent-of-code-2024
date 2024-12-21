defmodule Output do
  @moduledoc """
    Utility functions to generate output.
  """

  @spec matrix_to_str(Types.matrix(String.t())) :: String.t()
  @doc """
    Turns a matrix into a string for printing
  """
  def matrix_to_str(matrix) do
    Enum.reduce(matrix, "", fn {_, row}, outer_acc ->
      outer_acc <>
        "\n" <>
        Enum.reduce(row, "", fn {_, c}, acc -> acc <> c end)
    end)
  end

  @spec tuple_matrix_to_str(Types.tuple_matrix(String.t())) :: String.t()
  @doc """
    Turns a tuple matrix into a string for printing
  """
  def tuple_matrix_to_str(matrix) do
    {res, _} =
      matrix
      |> Enum.sort()
      |> Enum.reduce({"", 0}, fn {{i, _}, e}, {acc, acc_i} ->
        acc =
          if i > acc_i do
            acc <> "\n"
          else
            acc
          end

        acc = acc <> e
        {acc, i}
      end)

    res
  end
end

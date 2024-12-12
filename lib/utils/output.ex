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
end

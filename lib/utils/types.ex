defmodule Types do
  @moduledoc """
    Collection of types that a probably used in multiple places
  """

  @type matrix(type) :: %{non_neg_integer() => %{non_neg_integer() => type}}

  @spec string_to_integer(matrix(String.t())) :: matrix(integer())
  @doc """
    Turn a string matrix into an integer matrix

    Assumes all entries in the matrix are valid integers.
  """
  def string_to_integer(matrix) do
    Enum.map(matrix, fn {i, row} ->
      {i,
       Enum.map(row, fn {j, e} -> {j, String.to_integer(e)} end) |> Map.new()}
    end)
    |> Map.new()
  end
end

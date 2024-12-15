defmodule Types do
  @moduledoc """
    Collection of types that a probably used in multiple places
  """

  @type t :: integer() | String.t()

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

  @spec lines_to_matrix(Enumerable.t()) :: matrix(String.t())
  @doc """
    Convert a list of strings into a matrix
  """
  def lines_to_matrix(lines) do
    lines
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.filter(fn x -> x != "\n" end)
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Map.new()
    end)
    |> Enum.with_index(fn e, idx -> {idx, e} end)
    |> Map.new()
  end

  @spec update_matrix(matrix(t()), non_neg_integer(), non_neg_integer(), t()) ::
          matrix(t())
  def update_matrix(matrix, i, j, char) do
    Map.update!(matrix, i, fn row ->
      Map.update!(row, j, fn _ -> char end)
    end)
  end
end

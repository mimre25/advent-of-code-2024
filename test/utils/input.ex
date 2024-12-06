defmodule TestUtils.Input do
  @moduledoc false
  def str_to_list(str) do
    String.split(str, "\n", trim: false) |> Enum.map(fn s -> s <> "\n" end)
  end

  def str_to_matrix(str) do
    String.split(str, "\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Map.new()
    end)
    |> Enum.with_index(fn e, idx -> {idx, e} end)
    |> Map.new()
  end
end

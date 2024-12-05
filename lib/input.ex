defmodule Input do
  @moduledoc """
    Helpers to get the input
  """

  @doc """
    Function to stream the input as line of strings
  """
  def get_input(day) do
    File.stream!("input/#{day}")
  end

  @spec read_file_into_matrix(integer()) :: %{
          integer() => %{integer() => String.t()}
        }
  def read_file_into_matrix(day) do
    File.stream!("input/#{day}")
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Map.new()
    end)
    |> Enum.with_index(fn e, idx -> {idx, e} end)
    |> Map.new()
  end
end

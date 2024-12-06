defmodule Input do
  @moduledoc """
    Utility functions to get the input
  """

  @doc """
    Function to stream the input as line of strings
  """
  def get_input(day) do
    File.stream!("input/#{day}")
  end

  @doc """
    Read a file into a list of lines
  """
  def read_file_into_list(day) do
    File.stream!("input/#{day}") |> Enum.to_list()
  end

  @spec read_file_into_matrix(integer()) :: %{
          integer() => %{integer() => String.t()}
        }
  @doc """
    Read a file into a matrix of characters
  """
  def read_file_into_matrix(day) do
    File.stream!("input/#{day}")
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.filter(fn x -> x != "\n" end)
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Map.new()
    end)
    |> Enum.with_index(fn e, idx -> {idx, e} end)
    |> Map.new()
  end
end

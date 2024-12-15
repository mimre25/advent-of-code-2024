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
    Read a file into a single string
  """
  def read_file_into_string(day) do
    File.stream!("input/#{day}") |> Enum.join() |> String.trim_trailing()
  end

  @doc """
    Read a file into a list of lines
  """
  def read_file_into_list(day) do
    File.stream!("input/#{day}") |> Enum.to_list()
  end

  @spec read_file_into_matrix(non_neg_integer()) :: Types.matrix(String.t())
  @doc """
    Read a file into a matrix of characters
  """
  def read_file_into_matrix(day) do
    File.stream!("input/#{day}")
    |> Types.lines_to_matrix()
  end
end

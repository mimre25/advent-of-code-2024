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
end

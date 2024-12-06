defmodule TestUtils.Input do
  @moduledoc false
  def str_to_list(str) do
    String.split(str, "\n", trim: false) |> Enum.map(fn s -> s <> "\n" end)
  end
end

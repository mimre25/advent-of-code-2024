defmodule Types do
  @moduledoc """
    Collection of types that a probably used in multiple places
  """

  @type matrix :: %{non_neg_integer() => %{non_neg_integer() => String.t()}}
end

defmodule Memoization do
  @moduledoc """
    Small utility module for memoization
  """

  @doc """
    Update a key in the memoization cache with the given value

    Returns the value for convenience (eg usage in pipes)
  """
  def update(key, val) do
    Agent.update(MemoizationAgent, fn m -> Map.put(m, key, val) end)
    val
  end

  @doc """
    Get the value for the given key from the memoization cache

    Returns `nil` if the key isn't found.
  """
  def get(key) do
    Agent.get(MemoizationAgent, fn m -> Map.get(m, key) end)
  end

  @doc """
    Initialize the memoization cache
  """
  def init() do
    {:ok, _} = Agent.start_link(&Map.new/0, name: MemoizationAgent)
    :ok
  end

  @doc """
    Terminate the memoization cache

    Returns the value if given for convenience (eg usage in pipes).
    Returns :ok otherwise.
  """
  def stop(val \\ :ok) do
    Agent.stop(MemoizationAgent)
    val
  end
end

defmodule Progress do
  @moduledoc """
    Small utility module for having a progress bar
  """

  @doc """
    Increase the done value by 1 and renders the progress bar afterwards
  """
  def add_done() do
    Agent.update(ProgressAgent, fn {done, total} -> {done + 1, total} end)
    Progress.render()
  end

  @doc """
    Increase the done value by n and renders the progress bar afterwards
  """
  def add_done(n) do
    Agent.update(ProgressAgent, fn {done, total} -> {done + n, total} end)
    Progress.render()
  end

  @doc """
    Increase the total to do value by n
  """
  def add_total(n) do
    Agent.update(ProgressAgent, fn {done, total} -> {done, total + n} end)
  end

  @doc """
    Render the progress bar
  """
  def render() do
    {done, total} = Agent.get(ProgressAgent, &Function.identity/1)
    ProgressBar.render(done, total, suffix: :count)
  end

  @doc """
    Initialize the progress bar
  """
  def init() do
    {:ok, _} = Agent.start_link(fn -> {0.0, 0.0} end, name: ProgressAgent)
    :ok
  end
end

defmodule AdventOfCode.Three do
  @moduledoc false
  @doc false
  def main() do
    IO.puts("Part one:")
    Input.get_input(3) |> Enum.join() |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.get_input(3) |> Enum.join() |> part_two() |> IO.puts()
  end

  @spec parse_mul(String.t()) :: [String.t()]
  @doc """
    Parses an input string, ignoring everything but valid "mul" operations.
    A mul operation is only valid if it's of the form `mul(X,Y)` where X and Y
    are 1-3 digit integers.
    Note: spaces matter
  """
  def parse_mul(input) do
    Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)/, input)
    |> Enum.map(&Enum.join/1)
  end

  @spec parse(String.t()) :: [String.t()]
  @doc """
    Parses an input string, ignoring everything but valid "mul", "do", or "don't"  operations.
    A mul operation is only valid if it's of the form `mul(X,Y)` where X and Y
    are 1-3 digit integers. A "do" operation is only valid in the form `do()`.
    Similarly "don't" expression are only valid as `don't()`
    Note: spaces matter
  """
  def parse(input) do
    Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/, input)
    |> Enum.map(&Enum.join/1)
  end

  @spec multiply(String.t()) :: integer()
  @doc """
    Executes a "mul" operation.
    input is of form mul(X,Y), where X and Y are 1-3 digit integers
    returns X * Y
  """
  def multiply(input) do
    [_, x, y | _] = String.split(input, ~r"\(|,|\)")
    String.to_integer(x) * String.to_integer(y)
  end

  @spec execute([String.t()]) :: integer()
  @doc """
    Executes all operations of the given program in order.
  """
  def execute(program) do
    {_, result} =
      Enum.reduce(program, {:enabled, 0}, fn op, {mode, acc} ->
        {new_mode, res} = execute_op(op, mode)
        {new_mode, res + acc}
      end)

    result
  end

  @spec execute_op(String.t(), atom()) :: {atom(), integer()}
  @doc """
    Executes an operation within the given mode
    possible operations:
      - `do()` ~ Changes the mode to enabled
      - `don't()` ~ Changes the mode to disabled
      - `mul(X,Y)` ~ Represents a multiplication (see &multiply/1)

    modes:
      - :enabled ~ run the given operation
      - :disabled ~ ignore the given operation (except: do())
  """
  def execute_op(operation, _mode) when operation == "do()" do
    {:enabled, 0}
  end

  def execute_op(operation, _mode) when operation == "don't()" do
    {:disabled, 0}
  end

  def execute_op(operation, mode) do
    case mode do
      :disabled -> {:disabled, 0}
      :enabled -> {:enabled, multiply(operation)}
    end
  end

  @doc """
    Parse all mul operations, ignore the rest, execute them (multiplication), and sum the results
  """
  def part_one(input) do
    parse_mul(input) |> Enum.map(&multiply/1) |> Enum.sum()
  end

  @doc """
    Parse the given program, ignore all but mul,do, and don't operations and exectue the program
  """
  def part_two(input) do
    parse(input) |> execute()
  end
end

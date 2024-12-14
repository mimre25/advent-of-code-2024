defmodule AdventOfCode.Thirteen do
  @moduledoc false

  @typep button :: {non_neg_integer(), non_neg_integer()}
  @typep prize :: {non_neg_integer(), non_neg_integer()}

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(13) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(13) |> part_two() |> IO.puts()
  end

  @spec parse_button(String.t()) :: button()
  @doc false
  def parse_button(input) do
    [_, x, y] = Regex.run(~r/Button [AB]: X\+(\d+), Y\+(\d+)/, input)
    {String.to_integer(x), String.to_integer(y)}
  end

  @spec parse_prize(String.t()) :: prize()
  @doc false
  def parse_prize(input) do
    [_, x, y] = Regex.run(~r/Prize: X=(\d+), Y=(\d+)/, input)
    {String.to_integer(x), String.to_integer(y)}
  end

  @spec parse_game([String.t()]) :: {button(), button(), prize()}
  defp parse_game([input1, input2, input3]) do
    {parse_button(input1), parse_button(input2), parse_prize(input3)}
  end

  @spec play_game(button(), button(), prize()) ::
          {non_neg_integer(), non_neg_integer()} | nil
  @doc """
    Find a solution to the game by solving the set of linear equation given by the game
  """
  def play_game({ax, ay}, {bx, by}, {px, py}) do
    solve_equation({ax, ay}, {bx, by}, {px, py})
  end

  @spec check_equation(
          {non_neg_integer(), non_neg_integer()},
          {non_neg_integer(), non_neg_integer()},
          {non_neg_integer(), non_neg_integer()},
          {non_neg_integer(), non_neg_integer()}
        ) :: boolean()
  defp check_equation({a1, a2}, {b1, b2}, {s1, s2}, {a, b}) do
    a1 * a + b1 * b == s1 && a2 * a + b2 * b == s2
  end

  @spec solve_equation(
          {non_neg_integer(), non_neg_integer()},
          {non_neg_integer(), non_neg_integer()},
          {non_neg_integer(), non_neg_integer()}
        ) :: {non_neg_integer(), non_neg_integer()} | nil
  defp solve_equation({a1, a2}, {b1, b2}, {s1, s2}) do
    # a1 * A + b1 * B = s1
    # a2 * A + b2 * B = s2
    # a2/a1 = f
    # a2 - f*a1 + b2 - f*b1 = s2 - f * s1
    # =>
    # b2 - f*b2 = s2 - f * s1
    # kB = S
    # B = S/k
    f = a2 / a1
    k = b2 - b1 * f
    s = s2 - s1 * f
    b = s / k
    # a1 * A + b1* B = s1 =>  (s1 - b1*B)/a1
    a = (s1 - b1 * b) / a1

    # gotta love floats
    a_ = round(a)
    b_ = round(b)

    if check_equation({a1, a2}, {b1, b2}, {s1, s2}, {a_, b_}) do
      {a_, b_}
    else
      nil
    end
  end

  @spec compute_costs({non_neg_integer(), non_neg_integer()}) ::
          non_neg_integer()
  defp compute_costs({a, b}) do
    a * 3 + b
  end

  @doc """
    Compute the number of button presses for A and B and calculate the costs
  """
  def part_one(input) do
    input
    |> Enum.reject(&(&1 == "\n"))
    |> Enum.chunk_every(3)
    |> Enum.map(fn x ->
      {b1, b2, p} = parse_game(x)
      play_game(b1, b2, p)
    end)
    |> Enum.filter(&Function.identity/1)
    |> Enum.map(&compute_costs/1)
    |> Enum.sum()
  end

  def correct_prize({px, py}) do
    {px + 10_000_000_000_000, py + 10_000_000_000_000}
  end

  @doc """
    Compute the number of button presses for A and B and calculate the costs
  """
  def part_two(input) do
    input
    |> Enum.reject(&(&1 == "\n"))
    |> Enum.chunk_every(3)
    |> Enum.map(fn x ->
      {b1, b2, p} = parse_game(x)
      p_ = correct_prize(p)
      play_game(b1, b2, p_)
    end)
    |> Enum.filter(&Function.identity/1)
    |> Enum.map(&compute_costs/1)
    |> Enum.sum()
  end
end

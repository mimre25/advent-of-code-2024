defmodule AdventOfCode.Seventeen do
  # credo:disable-for-this-file Credo.Check.Readability.ModuleAttributeNames
  # don't want warnings for regA not being snake case
  @moduledoc false

  @adv 0
  @bxl 1
  @bst 2
  @jnz 3
  @bxc 4
  @out 5
  @bdv 6
  @cdv 7
  @regA 4
  @regB 5
  @regC 6

  @typep instr_index :: non_neg_integer()
  @typep opcode :: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7
  @typep program :: %{instr_index() => opcode()}

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(17) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(17) |> part_two() |> IO.puts()
  end

  @doc """
    Combo operands 0 through 3 represent literal values 0 through 3.
    Combo operand 4 represents the value of register A.
    Combo operand 5 represents the value of register B.
    Combo operand 6 represents the value of register C.
    Combo operand 7 is reserved and will not appear in valid programs.
  """
  def combo_operand(op) when op <= 3, do: op
  def combo_operand(4), do: load(@regA)
  def combo_operand(5), do: load(@regB)
  def combo_operand(6), do: load(@regC)

  defp weird_div(operand) do
    div(load(@regA), Integer.pow(2, operand))
  end

  @doc """
    The `adv` instruction (opcode 0) performs division. The numerator is the
    value in the A register. The denominator is found by raising 2 to the power
    of the instruction's combo operand. (So, an operand of 2 would divide A by
    4 (2^2); an operand of 5 would divide A by 2^B.) The result of the division
    operation is truncated to an integer and then written to the A register.

    The `bxl` instruction (opcode 1) calculates the bitwise XOR of register B and
    the instruction's literal operand, then stores the result in register B.

    The `bst` instruction (opcode 2) calculates the value of its combo operand
    modulo 8 (thereby keeping only its lowest 3 bits), then writes that value
    to the B register.

    The `jnz` instruction (opcode 3) does nothing if the A register is 0.
    However, if the A register is not zero, it jumps by setting the instruction
    pointer to the value of its literal operand; if this instruction jumps, the

    The `bxc` instruction (opcode 4) calculates the bitwise XOR of register B and
    register C, then stores the result in register B. (For legacy reasons, this
    instruction reads an operand but ignores it.)

    The `out` instruction (opcode 5) calculates the value of its combo operand
    modulo 8, then outputs that value. (If a program outputs multiple values,
    they are separated by commas.)

    The `bdv` instruction (opcode 6) works exactly like the `adv` instruction
    except that the result is stored in the B register. (The numerator is still
    read from the A register.)

    The `cdv` instruction (opcode 7) works exactly like the `adv` instruction
    except that the result is stored in the C register. (The numerator is still
    read from the A register.)
  """
  def eval(opc, operand)

  def eval(@adv, operand) do
    store(@regA, weird_div(combo_operand(operand)))
  end

  def eval(@bxl, operand) do
    store(@regB, Bitwise.bxor(load(@regB), operand))
  end

  def eval(@bst, operand) do
    store(@regB, Integer.mod(combo_operand(operand), 8))
  end

  def eval(@jnz, operand) do
    if load(@regA) != 0 do
      # use operand - 2 here to avoid handling of "not + 2" on the outside
      Agent.update(StateAgent, fn m -> Map.put(m, :ic, operand - 2) end)
    end
  end

  def eval(@bxc, _operand) do
    store(@regB, Bitwise.bxor(load(@regB), load(@regC)))
  end

  def eval(@out, operand) do
    res = Integer.mod(combo_operand(operand), 8)

    Agent.update(StateAgent, fn m ->
      Map.update!(m, :output, fn o -> [res | o] end)
    end)
  end

  def eval(@bdv, operand) do
    store(@regB, weird_div(combo_operand(operand)))
  end

  def eval(@cdv, operand) do
    store(@regC, weird_div(combo_operand(operand)))
  end

  defp load(reg) do
    Agent.get(StateAgent, fn m -> m[reg] end)
  end

  defp store(reg, val) do
    Agent.update(StateAgent, fn m -> Map.put(m, reg, val) end)
  end

  defp execute(opc, operand) do
    eval(opc, operand)

    # no need to ignore this for jnz as we jump to n-2 there
    Agent.update(StateAgent, fn m ->
      Map.update!(m, :ic, fn v -> v + 2 end)
    end)
  end

  @spec run_program(program()) :: nil
  def run_program(program) do
    ic = Agent.get(StateAgent, fn m -> m[:ic] end)

    case Map.get(program, ic) do
      nil ->
        nil

      opc ->
        operand = Map.get(program, ic + 1)
        execute(opc, operand)
        run_program(program)
    end
  end

  def parse_reg_value(line) do
    [v] = Regex.run(~r/\d+/, line)
    String.to_integer(v)
  end

  def start_program({a, b, c}, program) do
    _ =
      Agent.start_link(
        fn ->
          %{@regA => a, @regB => b, @regC => c, :ic => 0, :output => []}
        end,
        name: StateAgent
      )

    run_program(program)
    res = Agent.get(StateAgent, fn m -> m[:output] end)

    Agent.stop(StateAgent)
    res |> Enum.reverse() |> Enum.join(",")
  end

  def parse_program(input) do
    input
    |> Enum.at(4)
    |> String.split(~r/:|,|\n| /, trim: true)
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index(fn e, idx -> {idx, e} end)
    |> Map.new()
  end

  @doc """
    Execute the given program
  """
  def part_one(input) do
    [a, b, c] = input |> Enum.take(3) |> Enum.map(&parse_reg_value/1)
    program = parse_program(input)
    start_program({a, b, c}, program)
  end

  @spec find_solution(
          {non_neg_integer(), non_neg_integer(), non_neg_integer()},
          program(),
          String.t()
        ) :: [non_neg_integer() | nil]
  defp find_solution({a, b, c}, program, program_str) do
    res =
      start_program({a, b, c}, program)

    cond do
      res == program_str ->
        [a]

      !String.ends_with?(program_str, res) ->
        [nil]

      String.length(res) > String.length(program_str) ->
        [nil]

      true ->
        Enum.concat(
          for i <- 0..8 do
            find_solution({a * 8 + i, b, c}, program, program_str)
          end
        )
    end
  end

  @doc """
    Find the lowest input value for which the program replicates itself
  """
  def part_two(input) do
    [_, b, c] = input |> Enum.take(3) |> Enum.map(&parse_reg_value/1)
    program = parse_program(input)

    program_str =
      input |> Enum.at(4) |> String.split(~r/ |:|\n/, trim: true) |> Enum.at(1)

    Enum.concat(
      for i <- 1..8 do
        find_solution({i, b, c}, program, program_str)
      end
    )
    |> Enum.reject(&(&1 == nil))
    |> Enum.min()
  end
end

defmodule AdventOfCode.Fifteen do
  @moduledoc false

  @typep position :: {non_neg_integer(), non_neg_integer()}
  @typep direction :: {0, 1} | {0, -1} | {1, 0} | {-1, 0}
  @typep field :: Types.matrix(String.t())

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_list(15) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_list(15) |> part_two() |> IO.puts()
  end

  defp find_robot_position_reducer({key, row}, {-1, -1}) do
    row_idx = Enum.find(row, {-1, -1}, fn {_, c} -> c == "@" end) |> elem(0)

    case row_idx do
      -1 -> {-1, -1}
      _ -> {key, row_idx}
    end
  end

  defp find_robot_position_reducer(_, acc) do
    acc
  end

  @spec find_robot_position(field()) :: position()
  defp find_robot_position(field) do
    Enum.to_list(field)
    |> Enum.reduce({-1, -1}, &find_robot_position_reducer/2)
  end

  @spec execute_instruction({field(), position()}, String.t()) ::
          {field(), position()}
  defp execute_instruction(state, instruction)

  defp execute_instruction(state, "\n"), do: state

  defp execute_instruction(state, instruction) do
    direction =
      case instruction do
        "^" -> {-1, 0}
        "<" -> {0, -1}
        ">" -> {0, 1}
        "v" -> {1, 0}
      end

    move_robot(state, direction)
  end

  @spec move_robot({field(), position()}, direction()) ::
          {field(), position()}
  defp move_robot({field, robot = {ri, rj}}, direction = {di, dj}) do
    nexti = ri + di
    nextj = rj + dj

    if can_move_to?(field, direction, {nexti, nextj}, field[nexti][nextj]) do
      {move({field, {nexti, nextj}}, direction, "@", field[nexti][nextj]),
       {nexti, nextj}}
    else
      {field, robot}
    end
  end

  @spec move({field(), position()}, direction(), String.t(), String.t()) ::
          field()
  @doc """
    Move the object given by "mover" to the next position

    State is the current field and the new position of mover,
    Direction is the direction of the movement, and c is the element currenlty
    in the position of the new position.

    A mover can be either the robot or a box.

    This function is probably the worst code ever - it has many cases, as it
    escalted a bit during part two and all the special cases for the 2-size boxes.
  """
  def move(state, direction, mover, c)

  def move({field, {nexti, nextj}}, {di, dj}, "@", "O") do
    updated_field =
      Types.update_matrix(field, nexti, nextj, "@")
      |> Types.update_matrix(nexti - di, nextj - dj, ".")

    move(
      {updated_field, {nexti + di, nextj + dj}},
      {di, dj},
      "O",
      updated_field[nexti + di][nextj + dj]
    )
  end

  def move({field, {nexti, nextj}}, {di, dj}, "O", "O") do
    move(
      {field, {nexti + di, nextj + dj}},
      {di, dj},
      "O",
      field[nexti + di][nextj + dj]
    )
  end

  def move({field, {nexti, nextj}}, {di, dj}, "@", ".") do
    Types.update_matrix(field, nexti, nextj, "@")
    |> Types.update_matrix(nexti - di, nextj - dj, ".")
  end

  def move({field, {nexti, nextj}}, _, "O", ".") do
    Types.update_matrix(field, nexti, nextj, "O")
  end

  #### [] boxes
  def move({field, {nexti, nextj}}, {di, dj}, "@", c)
      when c == "[" or c == "]" do
    updated_field =
      Types.update_matrix(field, nexti, nextj, "@")
      |> Types.update_matrix(nexti - di, nextj - dj, ".")

    if di == 0 do
      # sidewards movement
      move(
        {updated_field, {nexti + di, nextj + dj}},
        {di, dj},
        c,
        updated_field[nexti + di][nextj + dj]
      )
    else
      # up/down
      {j, other} = get_other_box_part(c)

      updated_field =
        updated_field |> Types.update_matrix(nexti, nextj + j, ".")

      updated_field =
        move(
          {updated_field, {nexti + di, nextj + dj}},
          {di, dj},
          c,
          updated_field[nexti + di][nextj + dj]
        )

      move(
        {updated_field, {nexti + di, nextj + dj + j}},
        {di, dj},
        other,
        updated_field[nexti + di][nextj + dj + j]
      )
    end
  end

  def move({field, {nexti, nextj}}, {di, 0}, mover, c)
      when mover == "]" and c == "[" do
    updated_field =
      Types.update_matrix(field, nexti, nextj, mover)
      |> Types.update_matrix(nexti, nextj + 1, ".")

    {j, other} = get_other_box_part(c)

    f =
      move(
        {updated_field, {nexti + di, nextj}},
        {di, 0},
        c,
        field[nexti + di][nextj]
      )

    f =
      move(
        {f, {nexti + di, nextj + j}},
        {di, 0},
        other,
        field[nexti + di][nextj + j]
      )

    f
  end

  def move({field, {nexti, nextj}}, {di, 0}, mover, c)
      when mover == "[" and c == "]" do
    updated_field =
      Types.update_matrix(field, nexti, nextj, mover)
      |> Types.update_matrix(nexti, nextj - 1, ".")

    {j, other} = get_other_box_part(c)

    f =
      move(
        {updated_field, {nexti + di, nextj}},
        {di, 0},
        c,
        field[nexti + di][nextj]
      )

    f =
      move(
        {f, {nexti + di, nextj + j}},
        {di, 0},
        other,
        field[nexti + di][nextj + j]
      )

    f
  end

  def move({field, {nexti, nextj}}, {di, 0}, mover, c)
      when (mover == "[" or mover == "]") and c == mover do
    updated_field =
      Types.update_matrix(field, nexti, nextj, mover)

    move(
      {updated_field, {nexti + di, nextj}},
      {di, 0},
      c,
      field[nexti + di][nextj]
    )
  end

  def move({field, {nexti, nextj}}, {di, dj}, mover, c)
      when (mover == "[" or mover == "]") and (c == "[" or c == "]") do
    updated_field = Types.update_matrix(field, nexti, nextj, mover)

    move(
      {updated_field, {nexti + di, nextj + dj}},
      {di, dj},
      c,
      field[nexti + di][nextj + dj]
    )
  end

  def move({field, {nexti, nextj}}, _, c, ".") when c == "[" or c == "]" do
    Types.update_matrix(field, nexti, nextj, c)
  end

  def move({field, {nexti, nextj}}, {_, 0}, c, ".")
      when c == "[" or c == "]" do
    Types.update_matrix(field, nexti, nextj, c)
  end

  defp get_other_box_part("["), do: {1, "]"}
  defp get_other_box_part("]"), do: {-1, "["}

  @spec can_move_to?(field(), direction(), position(), String.t()) :: boolean()
  defp can_move_to?(field, direction = {di, 0}, {ni, nj}, next_c)
       when next_c == "[" or next_c == "]" do
    cond do
      wall?(next_c) ->
        false

      box?(next_c) ->
        nexti = ni + di
        nextj = nj

        {j, _} = get_other_box_part(next_c)

        can_move_to?(field, direction, {nexti, nextj}, field[nexti][nextj]) &&
          can_move_to?(
            field,
            direction,
            {nexti, nextj + j},
            field[nexti][nextj + j]
          )

      true ->
        true
    end
  end

  defp can_move_to?(field, direction = {di, dj}, {ni, nj}, next_c) do
    cond do
      wall?(next_c) ->
        false

      box?(next_c) ->
        nexti = ni + di
        nextj = nj + dj
        can_move_to?(field, direction, {nexti, nextj}, field[nexti][nextj])

      true ->
        true
    end
  end

  defp wall?("#"), do: true
  defp wall?(_), do: false

  defp box?("O"), do: true
  defp box?("["), do: true
  defp box?("]"), do: true
  defp box?(_), do: false

  defp execute_instructions(state, instructions) do
    instructions
    |> Enum.reduce(state, fn i, acc ->
      execute_instruction(acc, i)
    end)
  end

  defp value(i, j, "["), do: j + 100 * i
  defp value(i, j, "O"), do: j + 100 * i
  defp value(_, _, _), do: 0

  defp calculate_value(field) do
    field
    |> Enum.reduce(0, fn {i, row}, acc ->
      Enum.reduce(row, 0, fn {j, c}, inner_acc ->
        inner_acc + value(i, j, c)
      end) + acc
    end)
  end

  @doc """
    Simulate the robots movement pushing boxes and calculate the sum of the "GPS" coordinates of the boxes
  """
  def part_one(input) do
    {field, [_ | instructions]} = input |> Enum.split_while(&(&1 != "\n"))
    field = field |> Types.lines_to_matrix()
    robot_pos = field |> find_robot_position()
    instructions = Enum.join(instructions) |> String.split("", trim: true)
    {field, _} = execute_instructions({field, robot_pos}, instructions)
    calculate_value(field)
  end

  @doc """
    If the tile is #, the new map contains ## instead.
    If the tile is O, the new map contains [] instead.
    If the tile is ., the new map contains .. instead.
    If the tile is @, the new map contains @. instead.
  """
  def update_input(input) do
    String.replace(input, "#", "##")
    |> String.replace("O", "[]")
    |> String.replace(".", "..")
    |> String.replace("@", "@.")
  end

  @doc """
    Simulate the robots movement pushing boxes and calculate the sum of the "GPS" coordinates of the boxes

    For this round, the field is updated with update_input/1
  """
  def part_two(input) do
    {field, [_ | instructions]} = input |> Enum.split_while(&(&1 != "\n"))

    field =
      field
      |> Enum.join()
      |> update_input()
      |> String.split("\n")
      |> Types.lines_to_matrix()

    robot_pos = field |> find_robot_position()
    instructions = Enum.join(instructions) |> String.split("", trim: true)
    {field, _} = execute_instructions({field, robot_pos}, instructions)
    calculate_value(field)
  end
end

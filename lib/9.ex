defmodule AdventOfCode.Nine do
  @moduledoc false
  require Integer

  @doc false
  def main() do
    IO.puts("Part one:")
    Input.read_file_into_string(9) |> part_one() |> IO.puts()
    IO.puts("Part two:")
    Input.read_file_into_string(9) |> part_two() |> IO.puts()
  end

  @spec build_disk([non_neg_integer()]) :: [String.t()]
  @doc """
    Build the disk based on the compressed view

    Turns 12345 into 0..111....22222
  """
  def build_disk(compressed_view) do
    {res, _} =
      compressed_view
      |> Enum.flat_map_reduce(0, fn e, acc ->
        disk_data =
          if Integer.is_even(acc) do
            Enum.take(Stream.cycle(["#{Integer.floor_div(acc, 2)}"]), e)
          else
            Enum.take(Stream.cycle(["."]), e)
          end

        {disk_data, acc + 1}
      end)

    res
  end

  defp find_empty_blocks(disk) do
    disk
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x == "." end)
    |> Enum.map(fn {_, idx} -> idx end)
  end

  defp defrag_disk(disk, empty_blocks) do
    disk_matrix =
      disk
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Map.new()

    defrag_blocks =
      disk
      |> Enum.filter(fn x -> x != "." end)
      |> Enum.reverse()
      |> Enum.take(Enum.count(empty_blocks))

    Enum.zip(empty_blocks, defrag_blocks)
    |> Enum.reduce(disk_matrix, fn {idx, val}, acc ->
      Map.replace!(acc, idx, val)
    end)
    |> Enum.sort()
    |> Enum.drop(-Enum.count(empty_blocks))
  end

  @spec compute_checksum([{non_neg_integer(), String.t()}]) :: non_neg_integer()
  @doc """
    Compute the disks checksum

    The checksum is derived by multiplying the index of each file block with the
    file id the block belongs to and summing the results.
    Empty blocks count as 0.
  """
  def compute_checksum(disk) do
    disk
    |> Enum.reduce(0, fn {idx, val}, acc ->
      if val == "." do
        acc
      else
        acc + String.to_integer(val) * idx
      end
    end)
  end

  @doc """
    Defrag the disk by moving file parts to any open slot and compute the checksum
  """
  def part_one(input) do
    disk =
      input
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> build_disk()

    empty_blocks = find_empty_blocks(disk)

    defrag_disk(disk, empty_blocks) |> compute_checksum()
  end

  defp get_files_sizes(disk) do
    disk
    |> Enum.group_by(&Function.identity/1)
    |> Enum.map(fn {file, elems} -> {file, Enum.count(elems)} end)
    |> Enum.filter(fn {file, _} -> file != "." end)
  end

  defp get_block_sizes(empty_blocks) do
    empty_blocks
    |> Enum.chunk_while(
      [-1],
      fn e, acc ->
        if e - Enum.at(acc, 0) > 1 do
          # to emit
          {:cont, {Enum.at(acc, -1), Enum.count(acc)}, [e]}
        else
          # to not emit
          {:cont, [e | acc]}
        end
      end,
      fn acc ->
        # to emit
        {:cont, {Enum.at(acc, -1), Enum.count(acc)}, acc}
      end
    )
    |> Enum.drop(1)
  end

  defp update_block_size(block_sizes, block_id, block_size, file_size)
       when block_size == file_size do
    Enum.filter(block_sizes, fn {id, _} -> block_id != id end)
  end

  defp update_block_size(block_sizes, block_id, _block_size, file_size) do
    Enum.map(block_sizes, fn {id, size} ->
      if id == block_id do
        {id + file_size, size - file_size}
      else
        {id, size}
      end
    end)
  end

  defp try_move_file(disk, block_sizes, _, _, nil), do: {disk, block_sizes}

  defp try_move_file(disk, block_sizes, file, file_size, {dest, block_size}) do
    updated_disk =
      Enum.concat([
        Enum.take(disk, dest),
        Enum.take(Stream.cycle([file]), file_size),
        Enum.drop(disk, dest + file_size)
        |> Enum.map(fn x ->
          if x == file do
            "."
          else
            x
          end
        end)
      ])

    updated_block_sizes =
      update_block_size(block_sizes, dest, block_size, file_size)

    {updated_disk, updated_block_sizes}
  end

  defp find_destinaion_block(file_index, block_index, block_size, file_size) do
    if file_index > block_index && block_size >= file_size do
      true
    else
      false
    end
  end

  defp defrag_disk_smart(disk_, files_sizes, block_sizes_) do
    {updated_disk, _} =
      files_sizes
      |> Enum.reduce({disk_, block_sizes_}, fn {file, file_size},
                                               {disk, block_sizes} ->
        file_id = Enum.find_index(disk, &(&1 == file))

        block =
          Enum.find(block_sizes, fn {block_id, size} ->
            find_destinaion_block(file_id, block_id, size, file_size)
          end)

        try_move_file(disk, block_sizes, file, file_size, block)
      end)

    updated_disk
  end

  @doc """
    Defrag the disk by moving whole files into empty blocks of a suitable size and compute the checksum
  """
  def part_two(input) do
    disk =
      input
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> build_disk()

    empty_blocks = find_empty_blocks(disk)

    file_sizes =
      get_files_sizes(disk)
      |> Enum.sort(fn {a, _}, {b, _} ->
        String.to_integer(a) <= String.to_integer(b)
      end)
      |> Enum.reverse()

    block_sizes = get_block_sizes(empty_blocks)

    disk = defrag_disk_smart(disk, file_sizes, block_sizes)

    disk
    |> Enum.with_index()
    |> Enum.map(fn {x, y} -> {y, x} end)
    |> compute_checksum()
  end
end

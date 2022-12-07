defmodule AdventOfCode2022.Day07 do
  def run(input_file_name) do
    # Create file system
    file_system =
      load_input(input_file_name)
      |> Enum.reduce(%{dirs: %{}, current_dir: [""]}, &run_command/2)

    # Get directory sizes
    total_size = get_dir_size(file_system, "")

    dir_sizes =
      Enum.map(file_system.dirs, fn {dirname, _files} -> get_dir_size(file_system, dirname) end)

    # Find the combined size of all folders with size less than or equal to 100000
    part1 =
      Enum.filter(dir_sizes, &(&1 <= 100_000))
      |> Enum.sum()

    remaining_space = 70_000_000 - total_size
    space_required = 30_000_000 - remaining_space

    # Find the smallest folder which can be removed to make room for the update
    part2 =
      Enum.filter(dir_sizes, &(&1 >= space_required))
      |> Enum.sort()
      |> List.first()

    {part1, part2}
  end

  def load_input(file_name) do
    File.read!("lib/day07/#{file_name}.txt")
    |> String.split("$ ", trim: true)
    |> Enum.drop(1)
    |> Enum.map(fn command_chunk ->
      String.split(command_chunk, ~r/\R/, trim: true)
      |> then(fn lines -> {hd(lines) |> String.split(" "), tl(lines)} end)
    end)
  end

  def run_command({["cd", ".."], _}, state = %{current_dir: [_current_dir | parent_dir]}) do
    %{state | current_dir: parent_dir}
  end

  def run_command({["cd", dir], _}, state = %{current_dir: current_dir}) do
    %{state | current_dir: [dir] ++ current_dir}
  end

  def run_command({["ls"], files}, state) do
    files =
      Map.new(files, fn file_line ->
        String.split(file_line, " ", trim: true)
        |> then(fn
          ["dir", name] -> {name, :dir}
          [size, name] -> {name, {:file, String.to_integer(size)}}
        end)
      end)

    dir_string = dir_stack_to_string(state.current_dir)
    dirs = Map.update(state.dirs, dir_string, files, &Map.merge(&1, files))
    %{state | dirs: dirs}
  end

  defp dir_stack_to_string(dir_stack) do
    Enum.reverse(dir_stack)
    |> Enum.join("/")
  end

  def get_dir_size(state, dir_name) do
    Enum.reduce(state.dirs[dir_name], 0, fn
      {sub_dir_name, :dir}, acc ->
        acc + get_dir_size(state, "#{dir_name}/#{sub_dir_name}")

      {_name, {:file, size}}, acc ->
        acc + size
    end)
  end
end

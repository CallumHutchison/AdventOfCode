defmodule AdventOfCode.Year2022.Day09 do
  import AdventOfCode.Utils

  def run(input_file_name) do
    input = load_input(input_file_name)

    part1 =
      trace_path(input, [new_string(2)])
      |> count_unique_tail_positions()

    part2 =
      trace_path(input, [new_string(10)])
      |> count_unique_tail_positions()

    {part1, part2}
  end

  def load_input(file_name) do
    File.read!("priv/inputs/2022/day09/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [dir, count] -> {dir_to_vector(dir), String.to_integer(count)} end)
  end

  def dir_to_vector("R"), do: {1, 0}
  def dir_to_vector("L"), do: {-1, 0}
  def dir_to_vector("U"), do: {0, 1}
  def dir_to_vector("D"), do: {0, -1}

  def trace_path(moves, string) do
    # Would it be cleaner to just transform the input into a list of vectors? e.g. expand 'R 4' to [R,R,R,R]
    Enum.reduce(moves, string, fn {direction, count}, path ->
      Enum.reduce(1..count, path, fn _, path = [head | _] ->
        [move_string_head(head, direction)] ++ path
      end)
    end)
  end

  def count_unique_tail_positions(path) do
    path
    |> Enum.map(&List.last/1)
    |> Enum.uniq()
    |> Enum.count()
  end

  def new_string(length) do
    Enum.map(1..length, fn _ -> {0, 0} end)
  end

  # Move the head of the snake and recursively update the tail
  def move_string_head([{hx, hy} | tail], {dx, dy}) do
    head = {hx + dx, hy + dy}
    [head] ++ update_tail(tail, head)
  end

  defp update_tail([], _parent_position), do: []

  defp update_tail([head = {x, y} | tail], _parent = {px, py}) do
    new_pos =
      case {px - x, py - y} do
        # Stay still if within 1 step of parent
        {dx, dy} when dx in -1..1 and dy in -1..1 -> head
        # Otherwise move at most 1 step on each axis towards parent
        {dx, dy} -> {x + clamp(dx, -1, 1), y + clamp(dy, -1, 1)}
      end

    [new_pos] ++ update_tail(tail, new_pos)
  end
end

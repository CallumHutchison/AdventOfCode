defmodule AdventOfCode2022.Day09 do
  alias AdventOfCode2022.Day09.Snake

  def run(input_file_name) do
    input = load_input(input_file_name)

    part1 =
      trace_path(input, [Snake.new(2)])
      |> count_unique_tail_positions()

    part2 =
      trace_path(input, [Snake.new(10)])
      |> count_unique_tail_positions()

    {part1, part2}
  end

  def load_input(file_name) do
    File.read!("lib/day09/#{file_name}.txt")
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
      Enum.reduce(1..count, path, fn _, path = [snake | _] ->
        [Snake.move(snake, direction)] ++ path
      end)
    end)
  end

  def count_unique_tail_positions(path) do
    path
    |> Enum.map(&List.last/1)
    |> Enum.uniq()
    |> Enum.count()
  end
end

defmodule AdventOfCode.Year2022.Day01 do
  def run(input_file_name) do
    input = load_input(input_file_name)
    {calculate_highest_calories(input), calculate_highest_calories(input, 3)}
  end

  def load_input(file_name) do
    File.read!("lib/advent_of_code/year2022/day01/#{file_name}.txt")
    |> String.split(~r/\R\R/)
    |> Enum.map(fn lines -> String.split(lines, ~r/\R/) |> Enum.map(&String.to_integer/1) end)
  end

  def calculate_highest_calories(input, count \\ 1) do
    Enum.map(input, &Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(count)
    |> Enum.sum()
  end
end

defmodule AdventOfCode.Year2022.Day04 do
  def run(input_file_name) do
    ranges =
      load_input(input_file_name)
      |> parse_ranges

    part1 = count_fully_overlapping_ranges(ranges)

    part2 = count_overlaps(ranges)

    {part1, part2}
  end

  def load_input(file_name) do
    File.read!("lib/advent_of_code/year2022/day04/#{file_name}.txt")
    |> String.split(~r/\R/)
  end

  def parse_ranges(input_lines) do
    input_lines
    |> Enum.map(fn line ->
      String.split(line, ",")
      |> Enum.map(fn range ->
        String.split(range, "-")
        |> Enum.map(&String.to_integer/1)
      end)
    end)
  end

  def count_fully_overlapping_ranges(ranges) do
    Enum.reduce(ranges, 0, fn
      [[a, b], [x, y]], acc
      when (a >= x and b <= y) or (x >= a and y <= b) ->
        acc + 1

      _, acc ->
        acc
    end)
  end

  def count_overlaps(ranges) do
    Enum.map(ranges, fn [[a, b], [x, y]] -> {a..b, x..y} end)
    |> Enum.reduce(0, fn
      {range1, range2}, acc ->
        cond do
          Range.disjoint?(range1, range2) -> acc
          true -> acc + 1
        end
    end)
  end
end

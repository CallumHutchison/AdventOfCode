defmodule AdventOfCode2022 do
  alias AdventOfCode2022

  @solutions [
    %{day: "01", title: "Calorie Counting", function: &AdventOfCode2022.Day01.run/1},
    %{day: "02", title: "Rock Paper Scissors", function: &AdventOfCode2022.Day02.run/1},
    %{day: "03", title: "Rucksack Reorganization", function: &AdventOfCode2022.Day03.run/1},
    %{day: "04", title: "Camp Cleanup", function: &AdventOfCode2022.Day04.run/1},
    %{day: "05", title: "Supply Stacks", function: &AdventOfCode2022.Day05.run/1},
    %{day: "06", title: "Tuning Trouble", function: &AdventOfCode2022.Day06.run/1},
    %{day: "07", title: "No Space Left On Device", function: &AdventOfCode2022.Day07.run/1},
    %{day: "08", title: "Treetop Tree House", function: &AdventOfCode2022.Day08.run/1},
    %{day: "09", title: "Rope Bridge", function: &AdventOfCode2022.Day09.run/1},
    %{day: "10", title: "Cathode-Ray Tube", function: &AdventOfCode2022.Day10.run/1},
    %{day: "11", title: "Monkey in the Middle", function: &AdventOfCode2022.Day11.run/1},
    %{day: "12", title: "Hill Climbing Algorithm", function: &AdventOfCode2022.Day12.run/1},
    %{day: "13", title: "Distress Signal", function: &AdventOfCode2022.Day13.run/1}
  ]

  @table_mapping [
    {"Day", :day},
    {"Title", :title},
    {"Part 1 Answer", :part1},
    {"Part 2 Answer", :part2},
    {"Total execution time (s)", :time}
  ]

  def run do
    @solutions
    |> Enum.map(&Task.async(fn -> time_task(&1) end))
    |> Enum.map(&Task.await(&1, 10000))
    |> Scribe.print(data: @table_mapping)

    :ok
  end

  defp time_task(%{day: day, title: title, function: nil}) do
    %{day: day, title: title, part1: "n/a - Done in JS", part2: "n/a - Done in JS", time: "n/a"}
  end

  defp time_task(%{day: day, title: title, function: function}) do
    {time, {part1, part2}} = :timer.tc(function, ["input"])
    %{day: day, title: title, part1: part1, part2: part2, time: time / 1_000_000}
  end
end

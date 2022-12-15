defmodule AdventOfCode.Year2022 do
  @solutions [
    %{
      year: "2022",
      day: "01",
      title: "Calorie Counting",
      function: &AdventOfCode.Year2022.Day01.run/1
    },
    %{
      year: "2022",
      day: "02",
      title: "Rock Paper Scissors",
      function: &AdventOfCode.Year2022.Day02.run/1
    },
    %{
      year: "2022",
      day: "03",
      title: "Rucksack Reorganization",
      function: &AdventOfCode.Year2022.Day03.run/1
    },
    %{
      year: "2022",
      day: "04",
      title: "Camp Cleanup",
      function: &AdventOfCode.Year2022.Day04.run/1
    },
    %{
      year: "2022",
      day: "05",
      title: "Supply Stacks",
      function: &AdventOfCode.Year2022.Day05.run/1
    },
    %{
      year: "2022",
      day: "06",
      title: "Tuning Trouble",
      function: &AdventOfCode.Year2022.Day06.run/1
    },
    %{
      year: "2022",
      day: "07",
      title: "No Space Left On Device",
      function: &AdventOfCode.Year2022.Day07.run/1
    },
    %{
      year: "2022",
      day: "08",
      title: "Treetop Tree House",
      function: &AdventOfCode.Year2022.Day08.run/1
    },
    %{
      year: "2022",
      day: "09",
      title: "Rope Bridge",
      function: &AdventOfCode.Year2022.Day09.run/1
    },
    %{
      year: "2022",
      day: "10",
      title: "Cathode-Ray Tube",
      function: &AdventOfCode.Year2022.Day10.run/1
    },
    %{
      year: "2022",
      day: "11",
      title: "Monkey in the Middle",
      function: &AdventOfCode.Year2022.Day11.run/1
    },
    %{
      year: "2022",
      day: "12",
      title: "Hill Climbing Algorithm",
      function: &AdventOfCode.Year2022.Day12.run/1
    },
    %{
      year: "2022",
      day: "13",
      title: "Distress Signal",
      function: &AdventOfCode.Year2022.Day13.run/1
    },
    %{
      year: "2022",
      day: "14",
      title: "Regolith Reservoir",
      function: &AdventOfCode.Year2022.Day14.run/1
    }
  ]

  def run do
    @solutions
    |> Enum.map(&time_task(&1))
  end

  defp time_task(%{day: day, title: title, function: nil}) do
    %{day: day, title: title, part1: "n/a - Done in JS", part2: "n/a - Done in JS", time: "n/a"}
  end

  defp time_task(%{year: year, day: day, title: title, function: function}) do
    {time, {part1, part2}} = :timer.tc(function, ["input"])
    %{year: year, day: day, title: title, part1: part1, part2: part2, time: time / 1_000_000}
  end
end

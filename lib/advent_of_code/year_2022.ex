defmodule AdventOfCode.Year2022 do
  @solutions [
    %{
      year: 2022,
      day: 1,
      title: "Calorie Counting",
      function: &AdventOfCode.Year2022.Day01.run/1
    },
    %{
      year: 2022,
      day: 2,
      title: "Rock Paper Scissors",
      function: &AdventOfCode.Year2022.Day02.run/1
    },
    %{
      year: 2022,
      day: 3,
      title: "Rucksack Reorganization",
      function: &AdventOfCode.Year2022.Day03.run/1
    },
    %{
      year: 2022,
      day: 4,
      title: "Camp Cleanup",
      function: &AdventOfCode.Year2022.Day04.run/1
    },
    %{
      year: 2022,
      day: 5,
      title: "Supply Stacks",
      function: &AdventOfCode.Year2022.Day05.run/1
    },
    %{
      year: 2022,
      day: 6,
      title: "Tuning Trouble",
      function: &AdventOfCode.Year2022.Day06.run/1
    },
    %{
      year: 2022,
      day: 7,
      title: "No Space Left On Device",
      function: &AdventOfCode.Year2022.Day07.run/1
    },
    %{
      year: 2022,
      day: 8,
      title: "Treetop Tree House",
      function: &AdventOfCode.Year2022.Day08.run/1
    },
    %{
      year: 2022,
      day: 9,
      title: "Rope Bridge",
      function: &AdventOfCode.Year2022.Day09.run/1
    },
    %{
      year: 2022,
      day: 10,
      title: "Cathode-Ray Tube",
      function: &AdventOfCode.Year2022.Day10.run/1
    },
    %{
      year: 2022,
      day: 11,
      title: "Monkey in the Middle",
      function: &AdventOfCode.Year2022.Day11.run/1
    },
    %{
      year: 2022,
      day: 12,
      title: "Hill Climbing Algorithm",
      function: &AdventOfCode.Year2022.Day12.run/1
    },
    %{
      year: 2022,
      day: 13,
      title: "Distress Signal",
      function: &AdventOfCode.Year2022.Day13.run/1
    },
    %{
      year: 2022,
      day: 14,
      title: "Regolith Reservoir",
      function: &AdventOfCode.Year2022.Day14.run/1
    }
  ]

  def run do
    @solutions
    |> Enum.map(&AdventOfCode.time_task/1)
  end
end

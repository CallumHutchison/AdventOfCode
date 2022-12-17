defmodule AdventOfCode.Year2021 do
  @solutions [
    %{
      year: 2021,
      day: 1,
      title: "Sonar Sweep",
      function: &AdventOfCode.Year2021.Day01.run/1
    },
    %{year: 2021, day: 2, title: "Dive!", function: &AdventOfCode.Year2021.Day02.run(&1)},
    %{year: 2021, day: 3, title: "Binary Diagnostic", function: nil},
    %{
      year: 2021,
      day: 4,
      title: "Giant Squid",
      function: &AdventOfCode.Year2021.Day04.run(&1)
    },
    %{
      year: 2021,
      day: 5,
      title: "Hydrothermal Venture",
      function: &AdventOfCode.Year2021.Day05.run(&1)
    },
    %{
      year: 2021,
      day: 6,
      title: "Lanternfish",
      function: &AdventOfCode.Year2021.Day06.run(&1)
    },
    %{
      year: 2021,
      day: 7,
      title: "The Treachery of Whales",
      function: &AdventOfCode.Year2021.Day07.run(&1)
    },
    %{
      year: 2021,
      day: 8,
      title: "Seven Segment Search",
      function: &AdventOfCode.Year2021.Day08.run(&1)
    },
    %{
      year: 2021,
      day: 9,
      title: "Smoke Basin",
      function: &AdventOfCode.Year2021.Day09.run(&1)
    },
    %{
      year: 2021,
      day: 10,
      title: "Syntax Scoring",
      function: &AdventOfCode.Year2021.Day10.run(&1)
    },
    %{
      year: 2021,
      day: 11,
      title: "Dumbo Octopus",
      function: &AdventOfCode.Year2021.Day11.run(&1)
    },
    %{
      year: 2021,
      day: 12,
      title: "Passage Pathing",
      function: &AdventOfCode.Year2021.Day12.run(&1)
    },
    %{
      year: 2021,
      day: 13,
      title: "Transparent Origami",
      function: &AdventOfCode.Year2021.Day13.run(&1)
    },
    %{
      year: 2021,
      day: 14,
      title: "Extended Polymerization",
      function: &AdventOfCode.Year2021.Day14.run(&1)
    },
    %{year: 2021, day: 15, title: "Chiton", function: &AdventOfCode.Year2021.Day15.run(&1)},
    %{
      year: 2021,
      day: 16,
      title: "Packet Decoder",
      function: &AdventOfCode.Year2021.Day16.run(&1)
    },
    %{
      year: 2021,
      day: 17,
      title: "Tricky Shot",
      function: &AdventOfCode.Year2021.Day17.run(&1)
    },
    %{year: 2021, day: 18, title: "Snailfish", function: &AdventOfCode.Year2021.Day18.run(&1)}
  ]

  def run do
    @solutions
    |> Enum.map(fn solution -> Task.async(fn -> AdventOfCode.time_task(solution) end) end)
    |> Task.await_many(10_000)
  end
end

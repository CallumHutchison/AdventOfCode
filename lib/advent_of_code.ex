defmodule AdventOfCode do
  @years [
    AdventOfCode.Year2021,
    AdventOfCode.Year2022
  ]

  @table_mapping [
    {"Year", :year},
    {"Day", :day},
    {"Title", :title},
    {"Part 1 Answer", :part1},
    {"Part 2 Answer", :part2},
    {"Total execution time (s)", :time}
  ]

  def run do
    Enum.flat_map(@years, fn year -> year.run() end)
    |> Scribe.print(data: @table_mapping)
  end

  def run(module) do
    # TODO: fetch input from API
    module.run("input")
  end

  def run(module, input_file_name) do
    module.run(input_file_name)
  end

  def time_task(%{year: year, day: day, title: title, function: nil}) do
    %{
      year: year,
      day: day,
      title: title,
      part1: "n/a - Done in JS",
      part2: "n/a - Done in JS",
      time: "n/a"
    }
  end

  def time_task(%{year: year, day: day, title: title, function: function}) do
    {time, {part1, part2}} = :timer.tc(function, ["input"])
    %{year: year, day: day, title: title, part1: part1, part2: part2, time: time / 1_000_000}
  end

  def load_input(year, day, file_name) do
    File.read!("priv/inputs/#{year}/day#{day}/#{file_name}.txt")
  end

  def load_input_lines(year, day, file_name) do
    load_input(year, day, file_name)
    |> String.split(~r/\R/)
  end
end

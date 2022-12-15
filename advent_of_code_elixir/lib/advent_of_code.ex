defmodule AdventOfCode do
  @years [
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

  def run_all do
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
end

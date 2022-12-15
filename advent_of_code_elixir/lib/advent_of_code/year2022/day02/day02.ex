defmodule AdventOfCode.Year2022.Day02 do
  @winscore 6
  @drawscore 3
  @losescore 0

  @rockscore 1
  @paperscore 2
  @scissorscore 3

  def run(input_file_name) do
    input = load_input(input_file_name)

    {choose_player_part1(input) |> get_game_results() |> Enum.sum(),
     choose_player_part2(input) |> get_game_results() |> Enum.sum()}
  end

  def load_input(file_name) do
    File.read!("lib/advent_of_code/year2022/day02/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(fn lines ->
      String.split(lines, " ")
      |> Enum.map(fn
        "A" -> :rock
        "B" -> :paper
        "C" -> :scissors
        x -> x
      end)
    end)
  end

  def choose_player_part1(input) do
    Enum.map(input, fn
      [opponent, "X"] -> [opponent, :rock]
      [opponent, "Y"] -> [opponent, :paper]
      [opponent, "Z"] -> [opponent, :scissors]
    end)
  end

  def choose_player_part2(input) do
    Enum.map(input, fn
      [:rock, "X"] -> [:rock, :scissors]
      [:rock, "Y"] -> [:rock, :rock]
      [:rock, "Z"] -> [:rock, :paper]
      [:paper, "X"] -> [:paper, :rock]
      [:paper, "Y"] -> [:paper, :paper]
      [:paper, "Z"] -> [:paper, :scissors]
      [:scissors, "X"] -> [:scissors, :paper]
      [:scissors, "Y"] -> [:scissors, :scissors]
      [:scissors, "Z"] -> [:scissors, :rock]
    end)
  end

  def get_game_results(guide) do
    Enum.map(guide, fn
      [:rock, :rock] -> @drawscore + @rockscore
      [:rock, :paper] -> @winscore + @paperscore
      [:rock, :scissors] -> @losescore + @scissorscore
      [:paper, :rock] -> @losescore + @rockscore
      [:paper, :paper] -> @drawscore + @paperscore
      [:paper, :scissors] -> @winscore + @scissorscore
      [:scissors, :rock] -> @winscore + @rockscore
      [:scissors, :paper] -> @losescore + @paperscore
      [:scissors, :scissors] -> @drawscore + @scissorscore
    end)
  end
end

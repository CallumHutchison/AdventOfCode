defmodule AdventOfCode.Year2021.Day02.Part1 do
  def run(input_file_name) do
    load_input(input_file_name)
    |> parse_distances
    |> multiply_distances
  end

  defp load_input(file_name) do
    {:ok, input} = File.read("priv/inputs/2021/day02/#{file_name}.txt")

    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line -> String.split(line, " ") end)
    |> Enum.map(fn [command | distance] ->
      {command, Enum.at(distance, 0) |> String.to_integer()}
    end)
  end

  defp parse_distances(commands) do
    Enum.reduce(
      commands,
      {0, 0},
      fn {command, distance}, {horizontal, vertical} ->
        case command do
          "forward" -> {horizontal + distance, vertical}
          "up" -> {horizontal, vertical - distance}
          "down" -> {horizontal, vertical + distance}
        end
      end
    )
  end

  defp multiply_distances({horizontal, vertical}) do
    horizontal * vertical
  end
end

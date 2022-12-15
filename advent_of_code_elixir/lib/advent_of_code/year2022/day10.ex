defmodule AdventOfCode.Year2022.Day10 do
  def run(input_file_name) do
    input = load_input(input_file_name)
    output = run_program(input) |> Enum.reverse()

    part1 =
      Enum.map([20, 60, 100, 140, 180, 220], fn n -> Enum.at(output, n - 1) * n end)
      |> Enum.sum()

    File.write!("priv/inputs/2022/day10/part2_output.txt", display_screen(output, 40))

    {part1, "Visual Output"}
  end

  def load_input(file_name) do
    File.read!("priv/inputs/2022/day10/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, " ", trim: true))
  end

  def run_program(input) do
    Enum.reduce(input, [1], fn
      ["noop"], history ->
        [hd(history)] ++ history

      ["addx", num], history ->
        [hd(history) + String.to_integer(num), hd(history)] ++ history
    end)
  end

  def display_screen(register_values, screen_width) do
    Enum.chunk_every(register_values, screen_width)
    |> Enum.map(fn line ->
      line
      |> Enum.with_index()
      |> Enum.map(fn
        # i is pixel position of cursor on line
        # v is position of middle of sprite, which is 3 pixels wide
        # if i is within the sprite, then draw a pixel, otherwise don't draw
        {i, v} when i in (v - 1)..(v + 1) -> "#"
        _ -> " "
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
  end
end

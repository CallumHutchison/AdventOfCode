defmodule AdventOfCode.Year2022.Day06 do
  def run(input_file_name) do
    input = load_input(input_file_name)
    part1 = get_start_of_packet_marker(input)
    part2 = get_start_of_packet_marker(input, 14)
    {part1, part2}
  end

  def load_input(file_name) do
    File.read!("lib/advent_of_code/year2022/day06/#{file_name}.txt")
  end

  def get_start_of_packet_marker(packet, unique_chars_required \\ 4) do
    packet
    |> String.to_charlist()
    |> get_index_of_unique_chars(unique_chars_required)
  end

  def get_index_of_unique_chars(
        packet = [_head | tail],
        unique_chars_required,
        current_index \\ 0
      ) do
    case MapSet.new(Enum.take(packet, unique_chars_required)) |> MapSet.size() do
      ^unique_chars_required ->
        current_index + unique_chars_required

      _ ->
        get_index_of_unique_chars(tail, unique_chars_required, current_index + 1)
    end
  end
end

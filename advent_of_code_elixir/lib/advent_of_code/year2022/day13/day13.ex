defmodule AdventOfCode.Year2022.Day13 do
  def run(input_file_name) do
    input = load_input(input_file_name)

    part1 =
      Enum.chunk_every(input, 2)
      |> Enum.map(fn [a, b] -> {{a, b}, check_pair(a, b)} end)
      |> Enum.with_index()
      |> Enum.filter(fn {{_, correct}, _} -> correct end)
      |> Enum.map(&(elem(&1, 1) + 1))
      |> Enum.sum()

    divider_packets = [
      [[2]],
      [[6]]
    ]

    part2 =
      Enum.sort(input ++ divider_packets, &check_pair(&1, &2))
      |> then(fn packets ->
        (Enum.find_index(packets, &(&1 == [[2]])) + 1) *
          (Enum.find_index(packets, &(&1 == [[6]])) + 1)
      end)

    {part1, part2}
  end

  def load_input(input_file_name) do
    File.read!("lib/advent_of_code/year2022/day13/#{input_file_name}.txt")
    |> String.split(~r/\R/, trim: true)
    |> Enum.map(fn line -> Jason.decode!(line) end)
  end

  # If both values are integers, the lower integer should come first
  def check_pair([a | _], [b | _]) when is_integer(a) and is_integer(b) and a < b,
    do: true

  # If the left integer is higher than the right integer, the inputs are not in the right order
  def check_pair([a | _], [b | _]) when is_integer(a) and is_integer(b) and a > b,
    do: false

  # Otherwise, the inputs are the same integer. Continue checking the next part of the input
  def check_pair([a | tail_a], [b | tail_b]) when is_integer(a) and is_integer(b),
    do: check_pair(tail_a, tail_b)

  # If the lists are the same length and no comparison makes a decision about the order, continue checking the next part of the input
  def check_pair([], []), do: :inconclusive

  # If the left list runs out of items first, the inputs are in the right order
  def check_pair([], _), do: true

  # If the right list runs out of items first, the inputs are not in the right order
  def check_pair(_, []), do: false

  # If the lists are the same length and no comparison makes a decision about the order, continue checking the next part of the input
  def check_pair([a | tail_a], [b | tail_b]) when is_list(a) and is_list(b) do
    case check_pair(a, b) do
      :inconclusive -> check_pair(tail_a, tail_b)
      outcome -> outcome
    end
  end

  # If exactly one value is an integer, convert the integer to a list which contains
  # that integer as its only value, then retry the comparison
  def check_pair([a | tail_a], [b | tail_b]) when is_integer(a) and is_list(b),
    do: check_pair([[a] | tail_a], [b | tail_b])

  def check_pair([a | tail_a], [b | tail_b]) when is_list(a) and is_integer(b),
    do: check_pair([a | tail_a], [[b] | tail_b])
end

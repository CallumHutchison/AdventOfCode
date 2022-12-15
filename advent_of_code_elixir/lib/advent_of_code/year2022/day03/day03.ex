defmodule AdventOfCode.Year2022.Day03 do
  def run(input_file_name) do
    backpacks = load_backpacks(input_file_name)

    part1 =
      backpacks
      |> split_compartments()
      |> find_shared_compartment_items()
      |> calculate_item_priorities()
      |> Enum.sum()

    part2 =
      backpacks
      |> find_shared_group_items()
      |> calculate_item_priorities()
      |> Enum.sum()

    {part1, part2}
  end

  def load_backpacks(file_name) do
    File.read!("lib/advent_of_code/year2022/day03/#{file_name}.txt")
    |> String.split(~r/\R/)
  end

  def split_compartments(backpacks) do
    backpacks
    |> Enum.map(&String.split_at(&1, (String.length(&1) / 2) |> floor()))
  end

  def find_shared_compartment_items(compartments) do
    Enum.map(compartments, fn {comp1, comp2} ->
      MapSet.intersection(
        MapSet.new(String.to_charlist(comp1)),
        MapSet.new(String.to_charlist(comp2))
      )
    end)
  end

  def find_shared_group_items(backpacks) do
    backpacks
    |> Enum.chunk_every(3)
    |> Enum.map(fn group ->
      [b1, b2, b3] = Enum.map(group, fn backpack -> MapSet.new(String.to_charlist(backpack)) end)
      MapSet.intersection(b1, MapSet.intersection(b2, b3))
    end)
  end

  def calculate_item_priorities(shared_items) do
    shared_items
    |> Enum.flat_map(fn set -> MapSet.to_list(set) end)
    |> Enum.map(fn
      char when char in ?A..?Z ->
        27 + char - ?A

      char ->
        char - ?a + 1
    end)
  end
end

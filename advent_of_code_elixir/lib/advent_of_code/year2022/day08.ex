defmodule AdventOfCode.Year2022.Day08 do
  def run(input_file_name) do
    forest = load_input(input_file_name)

    part1 =
      Map.to_list(forest)
      |> Enum.filter(fn tree -> is_tree_visible?(forest, tree) end)
      |> Enum.count()

    part2 = Map.to_list(forest) |> Enum.map(&get_scenic_score(forest, &1)) |> Enum.max()
    {part1, part2}
  end

  def load_input(file_name) do
    File.read!("priv/inputs/2022/day08/#{file_name}.txt")
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      String.codepoints(line) |> Enum.map(&String.to_integer/1) |> Enum.with_index()
    end)
    |> Enum.with_index()
    |> Enum.reduce(
      %{},
      fn {cols, row}, acc ->
        Enum.map(cols, fn {value, col} -> {{row, col}, value} end) |> Map.new() |> Map.merge(acc)
      end
    )
  end

  def is_tree_visible?(forest, {pos, height}) do
    visible_from_dir?(forest, pos, {0, 1}, height) or
      visible_from_dir?(forest, pos, {1, 0}, height) or
      visible_from_dir?(forest, pos, {-1, 0}, height) or
      visible_from_dir?(forest, pos, {0, -1}, height)
  end

  def visible_from_dir?(forest, {x, y}, {dx, dy}, max_height) do
    check_pos = {x + dx, y + dy}

    case forest[check_pos] do
      # Reached end of grid - no tree in the grid for this pos
      nil -> true
      # Reached a tree of same size or greater
      height when height >= max_height -> false
      # Smaller tree - keep checking
      _ -> visible_from_dir?(forest, check_pos, {dx, dy}, max_height)
    end
  end

  def get_scenic_score(forest, {pos, height}) do
    get_view_distance(forest, pos, {0, 1}, height) *
      get_view_distance(forest, pos, {1, 0}, height) *
      get_view_distance(forest, pos, {0, -1}, height) *
      get_view_distance(forest, pos, {-1, 0}, height)
  end

  def get_view_distance(forest, {x, y}, {dx, dy}, max_height, current_distance \\ 0) do
    check_pos = {x + dx, y + dy}

    case forest[check_pos] do
      # Reached end of grid - no tree in the grid for this pos
      nil -> current_distance
      # Reached a tree of same size or greater
      height when height >= max_height -> current_distance + 1
      # Smaller tree - keep checking
      _ -> get_view_distance(forest, check_pos, {dx, dy}, max_height, current_distance + 1)
    end
  end
end

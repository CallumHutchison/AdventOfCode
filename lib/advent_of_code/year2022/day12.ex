defmodule AdventOfCode.Year2022.Day12 do
  alias AdventOfCode.Utils.Pathfinding

  def run(input_file_name) do
    %{connections: connections, start_pos: start_pos, end_pos: end_pos, elevations: elevations} =
      load_input(input_file_name)

    part1 = get_shortest_path_length(connections, start_pos, end_pos)

    possible_starts =
      Enum.filter(elevations, fn {{x, y}, height} ->
        height == 0 and
          not (elevations[{x + 1, y}] == 0 and elevations[{x - 1, y}] == 0 and
                 elevations[{x, y + 1}] == 0 and elevations[{x, y - 1}] == 0)
      end)
      |> Enum.map(&elem(&1, 0))

    part2 =
      Enum.map(possible_starts, fn pos ->
        Task.async(fn -> get_shortest_path_length(connections, pos, end_pos) end)
      end)
      |> Task.await_many(10_000)
      |> Enum.filter(&(&1 != :unreachable))
      |> Enum.sort(:asc)
      |> List.first()

    {part1, part2}
  end

  def load_input(file_name) do
    elevations =
      File.read!("priv/inputs/2022/day12/#{file_name}.txt")
      |> String.split(~r/\R/)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        String.to_charlist(line)
        |> Enum.with_index()
        |> Enum.map(fn
          {?S, x} -> {{x, y}, {0, :start}}
          {?E, x} -> {{x, y}, {25, :end}}
          {char, x} -> {{x, y}, {char - ?a, :normal}}
        end)
      end)

    {start_pos, _} = Enum.find(elevations, fn {_pos, {_elevation, type}} -> type == :start end)

    {end_pos, _} = Enum.find(elevations, fn {_pos, {_elevation, type}} -> type == :end end)

    elevations = Enum.map(elevations, fn {pos, {height, _}} -> {pos, height} end)

    connections =
      Enum.map(elevations, fn {pos, height} ->
        connected_spaces =
          Enum.filter(elevations, fn {move_pos, move_height} ->
            (move_height <= height or move_height == height + 1) and is_adjacent(pos, move_pos)
          end)
          |> Enum.map(fn {move_pos, _move_height} -> {move_pos, 1} end)

        {pos, connected_spaces}
      end)
      |> Map.new()

    %{
      start_pos: start_pos,
      end_pos: end_pos,
      elevations: Map.new(elevations),
      connections: connections
    }
  end

  def get_shortest_path_length(connections, start_pos, end_pos) do
    case Pathfinding.get_path(start_pos, end_pos, connections) do
      :unreachable -> :unreachable
      path -> Enum.count(path) - 1
    end
  end

  defp is_adjacent({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2) == 1
  end
end

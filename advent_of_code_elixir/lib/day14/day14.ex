defmodule AdventOfCode2022.Day14 do
  def run(input_file_name) do
    obstacles = load_input(input_file_name)

    {_, max_y} = Enum.max_by(obstacles, fn {_x, y} -> y end)
    part1 = MapSet.size(pour_sand(obstacles, {500, 0}, max_y + 1)) - MapSet.size(obstacles)

    part2 = MapSet.size(pour_sand(obstacles, {500, 0}, max_y + 1, false)) - MapSet.size(obstacles)

    {part1, part2}
  end

  def load_input(input_file_name) do
    File.read!("lib/day14/#{input_file_name}.txt")
    |> String.split(~r/\R/, trim: true)
    |> Enum.flat_map(&parse_line/1)
    |> MapSet.new()
  end

  defp parse_line(line) do
    String.split(line, " -> ")
    |> Enum.map(fn pos ->
      String.split(pos, ",")
      |> then(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
    end)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.flat_map(fn
      [{x, y1}, {x, y2}] ->
        Enum.map(y1..y2, fn y -> {x, y} end)

      [{x1, y}, {x2, y}] ->
        Enum.map(x1..x2, fn x -> {x, y} end)
    end)
  end

  @doc """
  Pour sand until either a grain of sand lands in the abyss, or the sand pile blocks the origin
  
  ## Arguments
  `obstacles`: A `%MapSet` of initial co-ordinates which the sand can collide with
  
  `origin`: A 2-length integer tuple `{x, y}` which represents the initial position that sand is simulated from
  
  `max_y`: The maximum y value that the sand can settle at. Behaviour depends on `is_abyss`
  
  `is_abyss`: If `true`, then sand which reaches `max_y` will be considered to have fallen into the abyss
  If `false`, then an infinitely-wide floor is considered to exist at a y value of `max_y` + 1, and sand can settle on it
  """
  def pour_sand(obstacles, origin, max_y, is_abyss \\ true) do
    case settle_sand(obstacles, origin, max_y, is_abyss) do
      ^origin ->
        MapSet.put(obstacles, origin)

      :abyss ->
        obstacles

      pos ->
        pour_sand(MapSet.put(obstacles, pos), origin, max_y, is_abyss)
    end
  end

  defp settle_sand(obstacles, position, max_y, is_abyss)
  defp settle_sand(_obstacles, {_x, max_y}, max_y, true), do: :abyss
  defp settle_sand(_obstacles, {x, max_y}, max_y, false), do: {x, max_y}

  defp settle_sand(obstacles, {x, y}, max_y, is_abyss) do
    if {x, y + 1} in obstacles do
      # Sand has hit an obstacle
      cond do
        # But it can move left
        {x - 1, y + 1} not in obstacles ->
          settle_sand(obstacles, {x - 1, y + 1}, max_y, is_abyss)

        # But it can move right
        {x + 1, y + 1} not in obstacles ->
          settle_sand(obstacles, {x + 1, y + 1}, max_y, is_abyss)

        # It has settled
        True ->
          {x, y}
      end
    else
      # Sand has not yet hit an obstacle
      settle_sand(obstacles, {x, y + 1}, max_y, is_abyss)
    end
  end
end

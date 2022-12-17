defmodule AdventOfCode.Year2022.Day15 do
  def run(input_file_name) do
    input = load_input(input_file_name)

    # part1 =
    #   Enum.reduce(input, MapSet.new(), fn sensor, zone ->
    #     case find_exclusion_zone_part1(sensor, 2_000_000) do
    #       [] -> zone
    #       coords -> MapSet.union(zone, MapSet.new(coords))
    #     end
    #   end)
    #   |> Enum.count()
    part1 = nil

    exclusion_zones =
      Enum.map(input, fn {{sx, sy}, {bx, by}} -> {{sx, sy}, abs(sx - bx) + abs(sy - by)} end)

    worker_count = 1000
    limit = 4_000_000
    chunk_size = div(limit, worker_count)

    part2 =
      Enum.map(1..worker_count, fn n ->
        Task.async(fn ->
          brute_force(
            exclusion_zones,
            {0, chunk_size * (n - 1)},
            chunk_size * n
          )
        end)
      end)
      |> Task.await_many(15 * 60 * 1000)
      |> Enum.find(&(&1 != nil))
      |> then(fn {x, y} -> x * 4_000_000 + y end)

    {part1, part2}
  end

  defp load_input(input_file_name) do
    File.read!("priv/inputs/2022/day15/#{input_file_name}.txt")
    |> String.split(~r/\R/, trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [sensor_x, sensor_y, beacon_x, beacon_y] =
      String.replace(line, ~r/[,:]/, "")
      |> String.split(" ")
      |> Enum.map(&(String.split(&1, "=") |> Enum.at(1)))
      |> Enum.filter(&(&1 != nil))
      |> Enum.map(&String.to_integer/1)

    {{sensor_x, sensor_y}, {beacon_x, beacon_y}}
  end

  def brute_force(_sensors, {_, y}, limit) when y >= limit, do: nil

  def brute_force(sensors, pos = {_x, y}, limit) do
    case find_sensor_intersections(pos, sensors) do
      [] ->
        pos

      intersecting_sensors ->
        x =
          Enum.map(intersecting_sensors, fn {{sx, sy}, range} ->
            sx + (range - abs(sy - y)) + 1
          end)
          |> Enum.max()

        if x < limit do
          brute_force(sensors, {x, y}, limit)
        else
          brute_force(sensors, {0, y + 1}, limit)
        end
    end
  end

  def find_exclusion_zone_part1({{sx, sy}, {bx, by}}, target_y) do
    {dx, dy} = {abs(sx - bx), abs(sy - by)}
    dist = dx + dy
    y_dist = abs(target_y - sy)

    if y_dist <= dist do
      x_dist = dist - y_dist

      for x <- -x_dist..dist,
          x + y_dist <= dist,
          {sx + x, target_y} != {bx, by},
          do: {sx + x, target_y}
    else
      []
    end
  end

  # def find_sensor_intersection(_, []), do: nil

  # def find_sensor_intersection({x, y} = pos, [{{sx, sy}, range} = sensor | other_sensors]) do
  #   dist = abs(x - sx) + abs(y - sy)

  #   if dist <= range do
  #     sensor
  #   else
  #     find_sensor_intersection(pos, other_sensors)
  #   end
  # end

  def find_sensor_intersections({x, y}, sensors) do
    Enum.filter(sensors, fn {{sx, sy}, range} -> abs(x - sx) + abs(y - sy) <= range end)
  end

  # def search(sensors, center, max_val, n \\ 0)

  # def search(_sensors, {pos_x, pos_y}, max_val, n)
  #     when pos_x + n > max_val or pos_y + n > max_val or pos_x - n < 0 or pos_y - n < 0,
  #     do: nil

  # def search(sensors, center = {pos_x, pos_y}, max_val, 0) do
  #   case picked_up_by_sensor?({pos_x, pos_y}, sensors) do
  #     true -> search(sensors, center, max_val, 1)
  #     false -> {pos_x, pos_y}
  #   end
  # end

  # def search(sensors, center = {pos_x, pos_y}, max_val, n) do
  #   IO.inspect(n)
  #   x_positions = for(x <- (pos_x - n)..(pos_x + n), do: [{x, pos_y + n}, {x, pos_y - n}])

  #   y_positions =
  #     for(
  #       y <- (pos_y - (n - 1))..(pos_y + (n - 1)),
  #       do: [{pos_x - n, y}, {pos_x + n, y}]
  #     )
  #     |> IO.inspect()

  #   beacon =
  #     List.flatten(x_positions ++ y_positions)
  #     |> IO.inspect()
  #     |> Enum.find(&(!picked_up_by_sensor?(&1, sensors)))

  #   case beacon do
  #     nil -> search(sensors, center, max_val, n + 1)
  #     _ -> beacon
  #   end
  # end
end

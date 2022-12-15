defmodule AdventOfCode.Year2022.Day09.Snake do
  import AdventOfCode.Year2022.Utils

  def new(length) do
    Enum.map(1..length, fn _ -> {0, 0} end)
  end

  # Move the head of the snake and recursively update the tail
  def move([{hx, hy} | tail], {dx, dy}) do
    head = {hx + dx, hy + dy}
    [head] ++ update_tail(tail, head)
  end

  defp update_tail([], _parent_position), do: []

  defp update_tail([head = {x, y} | tail], _parent = {px, py}) do
    new_pos =
      case {px - x, py - y} do
        # Stay still if within 1 step of parent
        {dx, dy} when dx in -1..1 and dy in -1..1 -> head
        # Otherwise move at most 1 step on each axis towards parent
        {dx, dy} -> {x + clamp(dx, -1, 1), y + clamp(dy, -1, 1)}
      end

    [new_pos] ++ update_tail(tail, new_pos)
  end
end

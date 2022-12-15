defmodule AdventOfCode.Year2022.Utils do
  def clamp(num, min, _max) when num < min, do: min
  def clamp(num, _min, max) when num > max, do: max
  def clamp(num, _min, _max), do: num
end

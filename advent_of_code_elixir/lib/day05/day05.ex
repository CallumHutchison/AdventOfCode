defmodule AdventOfCode2022.Day05 do
  def run(input_file_name) do
    [configuration_lines, solution_lines] = load_input(input_file_name)

    stacks = parse_starting_configuration(configuration_lines)
    solutions = String.split(solution_lines, ~r/\R/)
    part1 = run_solution(stacks, solutions)
    part2 = run_solution(stacks, solutions, true)
    {part1, part2}
  end

  def load_input(file_name) do
    File.read!("lib/day05/#{file_name}.txt")
    |> String.split(~r/\R\R/)
  end

  def parse_starting_configuration(lines) do
    [key | stacks] = String.split(lines, ~r/\R/) |> Enum.reverse()

    blank_stacks =
      String.split(key, " ", trim: true)
      |> Enum.reduce(%{}, fn char, acc -> Map.put(acc, String.to_integer(char), []) end)

    Enum.reduce(stacks, blank_stacks, fn line, acc ->
      nums =
        String.to_charlist(line)
        |> Enum.chunk_every(4)
        |> Enum.map(fn
          [_, char | _] when char in ?A..?Z -> char
          _ -> nil
        end)
        |> Enum.with_index(1)

      Enum.reduce(nums, acc, fn
        {nil, _index}, acc ->
          acc

        {value, index}, acc ->
          Map.update!(acc, index, fn
            [] -> [value]
            stack -> [value] ++ stack
          end)
      end)
    end)
  end

  def run_solution(stacks, solution_lines, retain_order \\ false) do
    Enum.reduce(solution_lines, stacks, fn line, stacks ->
      {quantity, start_stack, end_stack} = parse_solution_line(line)
      change = Enum.take(stacks[start_stack], quantity)

      Map.update!(stacks, start_stack, &Enum.drop(&1, quantity))
      |> Map.update!(end_stack, fn
        stack when retain_order ->
          change ++ stack

        stack ->
          Enum.reverse(change) ++ stack
      end)
    end)
    |> Map.to_list()
    |> Enum.sort()
    |> Enum.map(fn {_index, stack} -> List.first(stack) end)
  end

  def parse_solution_line(line) do
    String.split(line, " ")
    |> Enum.chunk_every(2)
    |> Enum.map(&List.last/1)
    |> then(fn [quantity, start_stack, end_stack] ->
      {String.to_integer(quantity), String.to_integer(start_stack), String.to_integer(end_stack)}
    end)
  end
end

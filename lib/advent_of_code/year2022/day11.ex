defmodule AdventOfCode.Year2022.Day11 do
  def run(input_file_name) do
    input = load_input(input_file_name)
    monkeys = Map.new(input)

    # Calculate lowest common multiple for the division tests.
    # Since the input file only contains primes we need to get the product of all of the dividors
    lcm =
      Enum.map(input, fn {_, %{test_dividor: test_dividor}} -> test_dividor end)
      |> Enum.product()

    part1 = calculate_monkey_business(monkeys, 20, 3)
    part2 = calculate_monkey_business(monkeys, 10000, 1, lcm)
    {part1, part2}
  end

  def load_input(file_name) do
    File.read!("priv/inputs/2022/day11/#{file_name}.txt")
    |> String.split(~r/\R\R/)
    |> Enum.map(&parse_monkey/1)
  end

  defp parse_monkey(monkey_definition) do
    [id, start_items, operation, test, test_outcome_true, test_outcome_false] =
      String.split(monkey_definition, ~r/\R/, trim: true)

    id = String.split(id, " ") |> List.last() |> String.slice(0..0) |> String.to_integer()

    start_items =
      String.replace(start_items, "  Starting items: ", "")
      |> String.split(", ", trim: true)
      |> Enum.map(&String.to_integer/1)

    operation =
      String.replace(operation, "  Operation: new = ", "")
      |> String.split(" ")
      |> parse_operation()

    test_dividor = String.split(test) |> List.last() |> String.to_integer()

    test_outcome_true = String.split(test_outcome_true) |> List.last() |> String.to_integer()
    test_outcome_false = String.split(test_outcome_false) |> List.last() |> String.to_integer()
    test = &if rem(&1, test_dividor) == 0, do: test_outcome_true, else: test_outcome_false

    {id,
     %{
       id: id,
       inspections: 0,
       test_dividor: test_dividor,
       items: start_items,
       operation: operation,
       test: test
     }}
  end

  def calculate_monkey_business(monkeys, rounds, dividor, modulo \\ nil) do
    play(monkeys, rounds, dividor, modulo)
    |> Map.to_list()
    |> Enum.map(fn {_, %{inspections: inspections}} -> inspections end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  defp parse_operation([operand_a, operator, operand_b]) do
    operation =
      case operator do
        "+" -> &(&1 + &2)
        "*" -> &(&1 * &2)
      end

    fn old ->
      operation.(parse_operation_arg(old, operand_a), parse_operation_arg(old, operand_b))
    end
  end

  defp parse_operation_arg(input, "old"), do: input
  defp parse_operation_arg(_input, constant), do: String.to_integer(constant)

  def play(monkeys, rounds, _divide_by, _modulo) when rounds <= 0 do
    monkeys
  end

  def play(monkeys, rounds, divide_by, modulo) do
    Enum.reduce(0..(Enum.count(monkeys) - 1), monkeys, fn n, monkeys ->
      monkey = monkeys[n]

      Enum.reduce(monkey.items, monkeys, fn worry_level, monkeys ->
        worry_level = monkey.operation.(worry_level) |> div(divide_by)

        worry_level = if is_nil(modulo), do: worry_level, else: rem(worry_level, modulo)

        pass_to = monkey.test.(worry_level)

        Map.update!(monkeys, pass_to, fn pass_to_monkey ->
          Map.update!(pass_to_monkey, :items, &(&1 ++ [worry_level]))
        end)
        |> Map.update!(n, fn passing_monkey ->
          Map.update!(passing_monkey, :items, &Enum.drop(&1, 1))
          |> Map.update!(:inspections, &(&1 + 1))
        end)
      end)
    end)
    |> play(rounds - 1, divide_by, modulo)
  end
end

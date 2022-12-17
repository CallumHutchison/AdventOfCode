defmodule AdventOfCode.Year2022.Day16 do
  def run(input_file_name) do
    graph =
      AdventOfCode.load_input_lines(2022, 16, input_file_name)
      |> parse_input()

    part1 = find_highest_pressure_from_start(graph, prune_graph(graph), 30)

    {part1, nil}
  end

  def parse_input(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.replace("Valve ", "")
      |> String.replace(" has flow rate=", ", ")
      |> String.replace("; tunnels lead to valves ", ", ")
      |> String.replace("; tunnel leads to valve ", ", ")
      |> String.split(", ")
      |> then(fn [valve, flow_rate | connections] ->
        {valve,
         %{flow_rate: String.to_integer(flow_rate), connections: Enum.map(connections, &{&1, 1})}}
      end)
    end)
    |> Map.new()
  end

  def prune_graph(graph) do
    nodes = Map.filter(graph, fn {_, %{flow_rate: flow_rate}} -> flow_rate > 0 end)

    Enum.map(nodes, fn {node, %{connections: connections, flow_rate: flow_rate}} ->
      {node,
       %{
         flow_rate: flow_rate,
         connections: Enum.flat_map(connections, &simplify_connection(graph, node, elem(&1, 0)))
       }}
    end)
    |> Map.new()
  end

  def simplify_connection(
        graph,
        node_a,
        node_b
      ) do
    simplify_connection(graph, node_a, node_b, MapSet.new([node_a]))
  end

  def simplify_connection(
        graph,
        node_a,
        node_b,
        visited_nodes
      ) do
    case graph[node_b] do
      %{flow_rate: 0, connections: connections} ->
        Enum.filter(connections, &(!MapSet.member?(visited_nodes, elem(&1, 0))))
        |> Enum.flat_map(fn {node, _} ->
          simplify_connection(graph, node_b, node, MapSet.put(visited_nodes, node_a))
        end)
        |> Enum.map(fn {node, cost} -> {node, cost + 1} end)
        |> Enum.group_by(&elem(&1, 0))
        |> Enum.map(&Enum.min_by(elem(&1, 1), fn {_, cost} -> cost end))
        |> List.flatten()

      _ ->
        [{node_b, 1}]
    end
  end

  def find_highest_pressure_from_start(graph, pruned_graph, max_time) do
    Map.get(graph, "AA").connections
    |> Enum.flat_map(&simplify_connection(graph, "AA", elem(&1, 0)))
    |> Enum.map(fn {node, starting_cost} ->
      find_highest_pressure(pruned_graph, node, %{
        pressure: 0,
        pressure_per_step: 0,
        time: starting_cost,
        max_time: max_time,
        opened_valves: MapSet.new()
      })
    end)
  end

  def find_highest_pressure(_graph, _node, state) when state.time >= state.max_time,
    do: state.pressure

  def find_highest_pressure(
        graph,
        node,
        state
      ) do
    IO.inspect({node, state.pressure, state.time})

    opened_valve_state =
      if node in state.opened_valves,
        do: [],
        else: [
          find_highest_pressure(graph, node, %{
            state
            | pressure: state.pressure + state.pressure_per_step,
              pressure_per_step: state.pressure_per_step + graph[node].flow_rate,
              time: state.time + 1,
              opened_valves: MapSet.put(state.opened_valves, node)
          })
        ]

    (opened_valve_state ++
       (Enum.filter(
          graph[node].connections,
          &(elem(&1, 1) <= state.max_time - state.time && elem(&1, 0) not in state.opened_valves)
        )
        |> Enum.map(fn {next_node, cost} ->
          find_highest_pressure(graph, next_node, %{
            state
            | pressure: state.pressure + state.pressure_per_step,
              time: state.time + cost
          })
        end)))
    |> Enum.max(fn -> state.pressure end)
  end
end

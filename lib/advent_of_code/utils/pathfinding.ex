defmodule AdventOfCode.Utils.Pathfinding do
  @doc """
  Calculate the shortest path between two positions
  
  ## Arguments:
  `start`: The ID of the starting position
  `target`: The ID of the position to create a path to
  `connections`: Either the connections between positions in the graph, with costs for each connection,
  or a function which takes in a position and returns an array of tuples `{connected_pos, cost}`
  
  ## Examples
  
      iex> AdventOfCode.Year2022.Utils.Pathfinding.get_path(
      ...>  {0, 0},
      ...>  {0, 2},
      ...>  %{{0,0}: [{{0,1}, 1}, {{1, 0}, 1}], {0,1}: [{{0, 2}, 1}]}
      ...>)
      [{0, 0}, {0, 1}, {0, 2}]
  """
  def get_path(start, target, connections) do
    get_path(target, connections, [%{position: start, distance: 0, parent: nil}], MapSet.new())
  end

  defp get_path(_target, _connections, [], _closed_set) do
    :unreachable
  end

  defp get_path(target, _connections, [node | _], _closed_set) when node.position == target,
    do: retrace_path(node)

  defp get_path(target, connections, [node | open_queue], closed_set) do
    queue =
      Enum.filter(
        connections[node.position],
        &(!MapSet.member?(closed_set, elem(&1, 0)))
      )
      |> Enum.reduce(open_queue, fn
        {pos, cost}, acc ->
          case Enum.find(acc, &(&1.position == pos)) do
            %{distance: current_distance} when current_distance <= node.distance + cost ->
              acc

            nil ->
              add_node(acc, %{
                position: pos,
                distance: node.distance + cost,
                parent: node
              })

            existing ->
              List.delete(acc, existing)
              |> add_node(%{
                position: pos,
                distance: node.distance + cost,
                parent: node
              })
          end
      end)

    get_path(target, connections, queue, MapSet.put(closed_set, node.position))
  end

  defp add_node([], node), do: [node]

  defp add_node([%{distance: head_dist} | _] = queue, %{distance: new_dist} = node)
       when new_dist < head_dist,
       do: [node | queue]

  defp add_node([head | tail], node),
    do: [head | add_node(tail, node)]

  defp retrace_path(nil), do: []
  defp retrace_path(%{position: pos, parent: parent}), do: [pos | retrace_path(parent)]
end

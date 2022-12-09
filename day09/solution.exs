defmodule Parse do
  @doc """
  Parse and follow the instructions. The accumulator is a {pos, visited} tuple,
  with pos as the list of all the current positions and visited all the positions
  the very last tail visited.
  """
  def parse(instruct, acc) do
    [direction, amount] = String.split(instruct)
    perform({direction, String.to_integer(amount)}, acc)
  end

  # Perform the instruction.
  # Case 1: Finished moving in direction, return the accumulator
  defp perform({_direction, 0}, acc), do: acc

  # Case 2: Move in direction
  defp perform({direction, amount}, {[hpos | tailpos], visited}) do
    new_hpos = move_head(direction, hpos)
    {new_visited, new_pos} = update_tails(new_hpos, tailpos, [new_hpos])

    perform({direction, amount - 1}, {new_pos, [new_visited | visited]})
  end

  # Move the head in direction
  defp move_head("U", {hx, hy}), do: {hx, hy - 1}
  defp move_head("D", {hx, hy}), do: {hx, hy + 1}
  defp move_head("L", {hx, hy}), do: {hx - 1, hy}
  defp move_head("R", {hx, hy}), do: {hx + 1, hy}

  # Update the position of the tail parts, depending on the head's position
  defp update_tails(head, [], acc_pos), do: {head, Enum.reverse(acc_pos)}
  defp update_tails(head, [ntail | rtail], acc_pos) do
    new_ntail = update_tail(head, ntail)
    update_tails(new_ntail, rtail, [new_ntail | acc_pos])
  end

  # Update an individual tail position, depending on its head's position
  defp update_tail(hpos = {hx, hy}, tpos = {tx, ty}) do
    case move_tail?(hpos, tpos) do
      true -> {update_tail_dim(hx, tx), update_tail_dim(hy, ty)}
      false -> tpos
    end
  end

  # Determine whether a next tail part needs to move, depending on its head
  defp move_tail?({hx, hy}, {tx, ty}) do
    [hx - tx, hy - ty]
    |> Enum.any?(fn v -> v < -1 || 1 < v end)
  end

  # Update a tail's position component, depending on the head's position
  defp update_tail_dim(h_dim, t_dim) do
    case h_dim - t_dim do
      n when n < 0 -> t_dim - 1
      n when n > 0 -> t_dim + 1
      _n -> t_dim
    end
  end
end

defmodule Puzzle do
  def solve(n) do
    start = Enum.map(0..n-1, fn _arg -> {0, 0} end)

    File.stream!("input", [:utf8], :line)
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({start, []}, &Parse.parse/2)
    |> elem(1)
    |> Enum.reverse()
    |> Enum.uniq()
    |> Enum.count()
  end
end

Puzzle.solve(2)
|> IO.inspect(label: "Part 1")

Puzzle.solve(10)
|> IO.inspect(label: "Part 2")

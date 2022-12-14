defmodule Simulation1 do
@doc """
Simulation for part 1 - sand eventually falls to into an abyss.
"""

  def run(drop_point, occupied) do
    last_row = last_row(occupied) + 1
    do_run(drop_point, occupied, last_row, 0)
  end

  defp do_run(drop_point, occupied, last_row, count) do
    case drop(drop_point, occupied, last_row) do
      {:end, _other} -> count
      {:rest, pos} -> do_run(drop_point, MapSet.put(occupied, pos), last_row, count + 1)
    end
  end

  def last_row(occupied) do
    {_max_x, max_y} = Enum.max_by(occupied, fn {_x, y} -> y end)
    max_y
  end

  def drop(from, occupied, stop_row)
  def drop({_x, y}, _occupied, stop_row) when y == stop_row, do: {:end, nil}
  def drop(pos = {x, y}, occupied, stop_row) do
    next = [0, -1 , 1]
      |> Stream.map(fn o -> {x + o, y + 1} end)
      |> Enum.find(fn p -> !MapSet.member?(occupied, p) end)

    case next do
      nil -> {:rest, pos}
      _ -> drop(next, occupied, stop_row)
    end
  end
end

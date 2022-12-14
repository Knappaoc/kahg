defmodule Simulation2 do
@doc """
Simulation for module 2 - infinite floor
"""

  def run(drop_point, occupied) do
    floor = last_row(occupied) + 2
    do_run(drop_point, occupied, floor, 0)
  end

  defp do_run(drop_point, occupied, floor, count) do
    case drop(drop_point, drop_point, occupied, floor) do
      {:end, _other} -> count + 1
      {:rest, pos} -> do_run(drop_point, MapSet.put(occupied, pos), floor, count + 1)
    end
  end

  def last_row(occupied) do
    {_max_x, max_y} = Enum.max_by(occupied, fn {_x, y} -> y end)
    max_y
  end

  def drop(start, from, occupied, stop_row)
  def drop(_start, pos = {_x, y}, _occupied, floor) when y + 1 == floor, do: {:rest, pos}
  def drop(start, pos = {x, y}, occupied, floor) do
    next = [0, -1 , 1]
      |> Stream.map(fn o -> {x + o, y + 1} end)
      |> Enum.find(fn p -> !MapSet.member?(occupied, p) end)

    case next do
      nil -> cond do
              pos === start -> {:end, nil}
              true -> {:rest, pos}
            end
      _ -> drop(start, next, occupied, floor)
    end
  end
end

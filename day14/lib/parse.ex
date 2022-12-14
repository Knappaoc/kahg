defmodule Parse do

  def parse(line) do
    line
    |> String.split("->")
    |> Stream.map(&parse_point/1)
    |> Enum.reduce([],  &collect_rock/2)
  end

  defp parse_point(point) do
    [x_text, y_text] = String.split(point, ",")
    {as_int(x_text), as_int(y_text)}
  end

  defp as_int(text), do: text |> String.trim() |> String.to_integer()

  defp collect_rock(elem, acc)
  defp collect_rock(elem, []), do: [elem]

  # e for current point in map, l for last added point
  defp collect_rock(dest = {e_x, e_y}, acc = [{l_x, l_y} | _before]) do
    {d_x, d_y} = {e_x - l_x, e_y - l_y}
    vector = {sign(d_x), sign(d_y)}
    fill(dest, vector, acc)
  end

  defp sign(0), do: 0
  defp sign(v) when v < 0, do: -1
  defp sign(v) when v > 0, do: 1

  defp fill(stop, _vector, acc = [last | _before]) when stop === last, do: acc
  defp fill(stop, vector = {v_x, v_y}, acc = [{l_x, l_y} | _before]) do
    fill(stop, vector, [{v_x + l_x, v_y + l_y} | acc])
  end
end

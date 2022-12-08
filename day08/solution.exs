defmodule Parse do

  def parse(line) do
    line
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Survey1 do
  def survey(map, cols, rows, position, acc)

  # End condition - bottom, right of map
  def survey(_map, cols, rows, {c, r}, acc) when c == cols - 1 and r == rows - 1, do: acc + 1

  # First column always visible
  def survey(map, cols, rows, {0, r}, acc), do: survey(map, cols, rows, {1, r}, acc + 1)

  # Last column always visible, go to the next row
  def survey(map, cols, rows, {c, r}, acc) when c == cols - 1, do: survey(map, cols, rows, {0, r + 1}, acc + 1)

  # First row always visible too
  def survey(map, cols, rows, {c, r}, acc) when r == 0 or r == rows - 1, do: survey(map, cols, rows, {c + 1, r}, acc + 1)

  # In all other cases, we are in the middle somewhere ...
  def survey(map, cols, rows, {c, r}, acc) do
    row = Enum.at(map, r)
    height = Enum.at(row, c)

    # Check visibility from above
    from_above = 0..r-1
    |> Enum.map(fn r -> Enum.at(map, r) |> Enum.at(c) end)
    |> Enum.all?(&(&1 < height))

    # Check visibility from below
    from_below = r+1..rows-1
    |> Enum.map(fn r -> Enum.at(map, r) |> Enum.at(c) end)
    |> Enum.all?(&(&1 < height))

    # Check visibility from the left
    from_left = row
    |> Enum.slice(0..c-1)
    |> Enum.all?(&(&1 < height))

    # Check visibility from the right
    from_right = row
    |> Enum.slice(c+1..length(row)-1)
    |> Enum.all?(&(&1 < height))

    case Enum.any?([from_above, from_below, from_left, from_right]) do
      true -> survey(map, cols, rows, {c + 1, r}, acc + 1)
      _other -> survey(map, cols, rows, {c + 1, r}, acc)
    end
  end
end

defmodule Survey2 do
  def survey2(_map, {_cols, rows}, {_c, r}, acc) when r >= rows, do: acc

  def survey2(map, map_size, pos = {c, r}, acc) do
    col = Enum.map(map, fn i -> Enum.at(i, c) end)
    row = Enum.at(map, r)

    next_pos = next(map_size, pos)
    v = score(col, r) * score(row, c)
    next_acc = [v | acc]
    survey2(map, map_size, next_pos, next_acc)
  end

  defp score(content, pos), do: survey_left(content, pos) * survey_right(content, pos)

  defp survey_left(_content, pos) when pos == 0, do: 0
  defp survey_left(content, pos) do
    max = Enum.at(content, pos)

    content
    |> Enum.slice(0..pos-1)
    |> Enum.reverse()
    |> count_elems(max, 0)
  end

  defp survey_right(content, pos) when pos == length(content) - 1, do: 0
  defp survey_right(content, pos) do
    max = Enum.at(content, pos)
    content
    |> Enum.slice(pos+1..length(content)-1)
    |> count_elems(max, 0)
  end

  # Count the number of trees (starting from index 0) that are visible.
  # Case 1: No more trees to count
  defp count_elems([], _max_value, count), do: count
  # Case 2: The next element doesn't exceed the max_value
  defp count_elems([next | remainder], max_value, count) when next < max_value do
    count_elems(remainder, max_value, count + 1)
  end
  # Case 3: The next element exceeds the max_value - the element still needs to be counted
  defp count_elems([_next | _remainder], _max_value, count), do: count + 1

  # Given the current position on the map, return the next position to visit.
  defp next(map_size, pos)
  # Case 1: Not at the end of the row yet
  defp next({cols, _rows}, {c, r}) when c == cols - 1, do: {0, r + 1}
  # Case 2: Now at end of the row. Start on the next one.
  defp next(_map_size, {c, r}), do: {c + 1, r}
end

map = File.stream!("input", [:utf8], :line)
|> Enum.map(&String.trim/1)
|> Enum.map(&Parse.parse/1)

rows = length(map)
cols = length(Enum.at(map, 0))

Survey1.survey(map, cols, rows, {0, 0}, 0)
|> IO.inspect(label: "count")

Survey2.survey2(map, {rows, cols}, {0, 0}, [])
|> Enum.max()
|> IO.inspect(label: "max score")

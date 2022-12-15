defmodule Parse do
  def parse(line) do
    [x1, y1, x2, y2] =
      Regex.scan(~r/-?\d+/, line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    {{x1, y1}, {x2, y2}}
  end
end

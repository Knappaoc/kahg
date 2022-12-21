defmodule Parse do
  def from(filename) do
    File.stream!(filename, [:utf8], :line)
    |> Enum.map(&parseLine/1)
    |> Enum.reduce(Map.new(), fn monkey, acc -> Map.put(acc, monkey.id, monkey) end)
  end

  def parseLine(line) do
    [name, instruct] = String.split(line, ":")
    parts = String.split(instruct)

    %Monkey{
      id: name,
      piece: parseContent(parts)
    }
  end

  defp parseContent([value]) do
    String.to_integer(value)
  end

  defp parseContent([left, op, right]) do
    {left, op, right}
  end
end

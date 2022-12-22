defmodule Parse do

  def from(filename) do
    # Step 1 - Collect all the lines (last line is not part of the map)
    contents = File.stream!(filename, [:utf8], :line)
      |> Enum.map(fn l -> String.replace(l, "\r", "") end)
      |> Enum.map(fn l -> String.replace(l, "\n", "") end)
      |> Enum.into([])

    # Step 2 - Parse all lines up to the last one as the map
    maze = contents
      |> Enum.slice(0..length(contents)-2)
      |> Enum.map(&String.graphemes/1)
      |> Enum.reject(&Enum.empty?/1)

    instruct = Regex.scan(~r/\d+|[LR]/, Enum.at(contents, -1))
      |> Stream.flat_map(&(&1))
      |> Enum.map(&parse_instruct/1)

    # Return as a tuple of maze and instruction
    {maze, instruct}
  end


  def parse_instruct("L"), do: :left
  def parse_instruct("R"), do: :right
  def parse_instruct(instruct), do: String.to_integer(instruct)
end

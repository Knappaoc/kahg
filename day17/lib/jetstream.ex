defmodule Jetstream do
  def from(filename) do
    filename
    |> File.stream!([:utf8], :line)
    |> Enum.at(0)
    |> parse()
  end

  def parse(line) do
    line
    |> String.graphemes()
    |> Enum.map(&get_shift/1)
    |> Stream.cycle()
  end

  def get_shift("<"), do: -1
  def get_shift(">"), do: 1
end

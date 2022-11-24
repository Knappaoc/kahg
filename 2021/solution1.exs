defmodule Functions do

  def window(x, []), do: [x]
  def window(x, [a]), do: [a, x]
  def window(x, [_, b]), do: [b, x]

  def filter([a, b], acc) when a < b, do: acc+1
  def filter(_, acc), do: acc
end

File.stream!("inputs", [:utf8], :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.to_integer/1)
  |> Stream.scan([], &Functions.window/2)
  |> Enum.reduce(0, &Functions.filter/2)
  |> IO.puts()

defmodule Functions do
  def window(x, {count, a}) when a < x, do: {count + 1, x}
  def window(x, {count, _}), do: {count, x}
end

{c, _} = File.stream!("inputs1", [:utf8], :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.to_integer/1)
  |> Enum.reduce({0, nil}, &Functions.window/2)

IO.puts(c)

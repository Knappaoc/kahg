defmodule Functions do
  def chunk_while(item, acc)
  def chunk_while("", acc), do: {:cont, acc, []}
  def chunk_while(item, acc), do: {:cont, [String.to_integer(item) | acc]}

  def chunk_end(acc)
  def chunk_end([]), do: {:cont, []}
  def chunk_end(acc), do: {:cont, acc, []}
end

# Stream each line in the file and collect the top 3 total calories.
{top, _} = File.stream!("inputs", [:utf8], :line)
  |> Stream.map(&String.trim/1)
  |> Stream.chunk_while([], &Functions.chunk_while/2, &Functions.chunk_end/1)
  |> Stream.reject(&Enum.empty?/1)
  |> Stream.map(fn values -> Enum.reduce(values, &(&1 + &2)) end)
  |> Enum.sort(:desc)
  |> Enum.split(3)

# Part 1: What is the highest total?
top
  |> Enum.at(0)
  |> IO.inspect(label: "Highest")

# Part 2: What is the sum of the 3 highest?
top
  |> Enum.reduce(0, &(&1 + &2))
  |> IO.inspect(label: "Top 3 sum")

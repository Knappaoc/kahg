defmodule Functions do
  def score([elf1, elf2, elf3], acc), do: acc + do_score(elf1, elf2, elf3, 0)

  def do_score([], _elf2, _elf3, acc), do: acc
  def do_score([item | remaining], elf2, elf3, acc) do
    filter = fn x -> x == item end
    if Enum.any?(elf2, filter) && Enum.any?(elf3, filter) do
      acc + item_priority(item)
    else
      do_score(remaining, elf2, elf3, acc)
    end
  end

  def item_priority(item) when ?a <= item and item <= ?z, do: item - ?a + 1
  def item_priority(item) when ?A <= item and item <= ?Z, do: item - ?A + 27
end

# Stream each line in the file and collect the total calories.
File.stream!("input", [:utf8], :line)
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_charlist/1)
|> Stream.chunk_every(3)
|> Enum.reduce(0, &Functions.score/2)
|> IO.inspect(label: "Score")

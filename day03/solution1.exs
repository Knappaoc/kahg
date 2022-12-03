defmodule Functions do
  def split(input) do
    length = Enum.count(input)
    Enum.split(input, div(length, 2))
  end

  def score({left, right}, acc), do: acc + do_score(left, right, 0, [])

  def do_score([], _right, score, _seen), do: score
  def do_score([item | remaining], right, score, seen) do
    if Enum.any?(seen, fn x -> x == item end) do
      do_score(remaining, right, score, seen)
    else
      do_score(remaining, right, score + score_item(item, right), [item | seen])
    end
  end

  def score_item(_item, []), do: 0
  def score_item(item, [item | _remaining]), do: item_priority(item)
  def score_item(item, [_other | remaining]), do: score_item(item, remaining)

  def item_priority(item) when ?a <= item and item <= ?z, do: item - ?a + 1
  def item_priority(item) when ?A <= item and item <= ?Z, do: item - ?A + 27
end

# Stream each line in the file and collect the total calories.
File.stream!("input", [:utf8], :line)
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_charlist/1)
|> Stream.map(&Functions.split/1)
|> Enum.reduce(0, &Functions.score/2)
|> IO.inspect(label: "Score")

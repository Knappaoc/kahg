pairs =
  File.stream!("input", [:utf8], :line)
  |> Stream.map(&String.trim/1)
  |> Stream.chunk_every(3)
  |> Enum.map(&Parse.parsePair/1)

filter = fn i ->
  {left, right} = Enum.at(pairs, i - 1)
  Packets.is_ordered(left, right)
end

1..length(pairs)
|> Enum.filter(filter)
|> IO.inspect(label: "part 1 accepted")
|> Enum.sum()
|> IO.inspect(label: "part 1 total")

ordered =
  [{[[2]], [[6]]} | pairs]
  |> Enum.flat_map(fn {left, right} -> [left, right] end)
  |> Enum.sort(&Packets.is_ordered/2)

first = Enum.find_index(ordered, fn x -> x == [[2]] end) + 1
second = Enum.find_index(ordered, fn x -> x == [[6]] end) + 1
IO.inspect(first, label: "part 2 index 1")
IO.inspect(second, label: "part 2 index 2")
IO.inspect(first * second, label: "part 2 product")

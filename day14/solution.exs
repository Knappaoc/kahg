points = File.stream!("input", [:utf8], :line)
|> Stream.map(&Parse.parse/1)
|> Enum.flat_map(&(&1))
|> Enum.into(MapSet.new())
# |> IO.inspect(label: "occupied")

Simulation1.run({500, 0}, points)
|> IO.inspect(label: "part 1")

Simulation2.run({500, 0}, points)
|> IO.inspect(label: "part 2")

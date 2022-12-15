# Advent of code 2022, day 15 (part 1)

# row = 10      # Value from the puzzle's sample
row = 2_000_000

pairs =
  File.stream!("input", [:utf8], :line)
  |> Stream.map(&Parse.parse/1)

# Find all sensors and beacons on the point. They should not be
# counted in the final result.
reject_cols =
  pairs
  |> Stream.flat_map(fn {sensor, beacon} -> [sensor, beacon] end)
  |> Stream.filter(fn {_x, y} -> y == row end)
  |> Enum.map(fn {x, _y} -> x end)

# Find the columns of interest (the columns of the sensor
# coverage intersecting with the row).
coi =
  pairs
  |> Stream.flat_map(fn pair -> Puzzle.cols_on_row(pair, row) end)
  |> Stream.uniq()
  |> Stream.reject(fn col -> col in reject_cols end)
  # This is just to make it easier to read the output.
  |> Enum.sort()
  |> IO.inspect(label: "cols")

length(coi)
|> IO.inspect(label: "length")

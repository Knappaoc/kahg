# Advent of code 2022, day 15 (part 2)

# size = {20, 20}           # The puzzle's sample
# Part two
size = {4_000_000, 4_000_000}

points =
  File.stream!("input", [:utf8], :line)
  |> Stream.map(&Parse.parse/1)
  |> Enum.map(fn {sensor, beacon} -> {sensor, Puzzle.distance(sensor, beacon)} end)

defmodule Part2 do
  @doc """
  Finds the spot that is not covered by the sensors. The sensors are expected to be given
  as a list of {sensor={x,y}, range}.
  """
  def find_spot(max_size, sensors) do
    do_find_spot(max_size, sensors, sensors)
  end

  # Recurively try to find a spot not covered by the sensors that is bounded in the region
  # (0, 0) to max_size. The algorithm works by checking the points just one point outside
  # of the sensors range (since we know that anything up to the sensor's range is covered).
  defp do_find_spot(max_size, remaining, sensors)
  defp do_find_spot(_msize, [], _sensors), do: nil

  defp do_find_spot(msize = {mx, my}, [sensor = {{sx, sy}, range} | remaining], points) do
    dist = abs(range) + 1

    res =
      -dist..dist
      |> Stream.flat_map(fn n -> [{sx + n, sy + dist - n}, {sx + n, sy - dist + n}] end)
      |> Stream.reject(fn {x, y} -> x < 0 || y < 0 || x > mx || y > my end)
      |> Enum.find(fn t -> !is_covered?(t, points, sensor) end)

    case res do
      nil -> do_find_spot(msize, remaining, points)
      s -> s
    end
  end

  @doc """
  Checks if a given spot is "covered" by another sensor, where the sensors are given
  as {sensor={x,y}, range}. The parameters are:
  t_spot: the spot to check if it is covered
  r_sensors: the list of sensors to check
  c_sensor: the sensor to skip (presumably because we already know it won't cover the point)
  """
  def is_covered?(t_spot, r_sensors, c_sensor)
  def is_covered?(_t_spot, [], _current), do: false

  # The "current" sensor can never cover the point, so we can skip it.
  def is_covered?(t_spot, [next | remaining], current) when next === current do
    is_covered?(t_spot, remaining, current)
  end

  def is_covered?(t_spot, [{s_spot, range} | remaining], current) do
    dist = Puzzle.distance(s_spot, t_spot)

    cond do
      dist <= range -> true
      true -> is_covered?(t_spot, remaining, current)
    end
  end
end

{sx, sy} =
  Part2.find_spot(size, points)
  |> IO.inspect(label: "Spot")

(sx * 4_000_000 + sy)
|> IO.inspect(label: "Freq")

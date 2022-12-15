defmodule Puzzle do
  @doc """
  Calculate the "taxi" distance between two points.
  """
  def distance({sx, sy}, {bx, by}), do: abs(bx - sx) + abs(by - sy)

  def cols_on_row({sensor = {_sx, sy}, beacon}, row) when sy == row do
    distance(sensor, beacon)
    |> do_cols_on_row(sensor)
  end

  # The sensor is above the row. In this case, the southern tip needs
  # to be below the row to intersect with the row.
  def cols_on_row({sensor = {sx, sy}, beacon}, row) when sy < row do
    dist = distance(sensor, beacon)

    # sy + distance is the southern most point of the range.
    # so sy + distance - row is the distance "left over" from
    # travelling straight from sy to the row
    radius = sy + dist - row

    do_cols_on_row(radius, sx)
  end

  # The sensor is below the row. The northern tip needs to be
  # above the row to intersect the row.
  def cols_on_row({sensor = {sx, sy}, beacon}, row) when sy > row do
    # This calculation is similar to above, only with the row
    # being above the sensor
    radius = row - (sy - distance(sensor, beacon))

    do_cols_on_row(radius, sx)
  end

  # Used to get the columns centered around a column on a row. The radius
  # is how far the columns extend to the left and right of the center.
  # A negative value means the row is out of range and no points exist on
  # the row.
  defp do_cols_on_row(radius, _center) when radius < 0, do: []

  defp do_cols_on_row(radius, center) do
    -radius..radius
    |> Enum.map(fn r -> center + r end)
  end
end

defmodule Simulation do
  defmodule Accumulator do
    defstruct shape_no: 0, js_no: 0, height: 0, points: MapSet.new()
  end

  defmodule Params do
    defstruct start: {2, 4},
              width: 0,
              shape_stream: &Simulation.streamDefault/1,
              js_stream: &Simulation.streamDefault/1
  end

  def streamDefault(_index), do: []

  def run(width, shape_stream, js_stream, max_shapes) do
    params = %Params{
      width: width,
      shape_stream: shape_stream,
      js_stream: js_stream
    }

    Enum.reduce(1..max_shapes, %Accumulator{}, fn _i, acc -> next_shape(params, acc) end)
  end

  def next_shape(params, acc) do
    {sx, sy} = params.start

    # Translate the shape to place at starting position
    shape =
      Enum.at(params.shape_stream, acc.shape_no)
      |> Enum.map(fn {x, y} -> {x + sx, y + acc.height + sy} end)

    next_acc = %{acc | shape_no: acc.shape_no + 1}

    drop(shape, params, next_acc)
  end

  defp drop(shape, params, acc) do
    # Apply next jet stream to get the candidate shape position.
    js = Enum.at(params.js_stream, acc.js_no)
    next_acc = %{acc | js_no: acc.js_no + 1}
    {_res, js_shape} = move(shape, {js, 0}, params, acc)

    # Then, try move down
    case move(js_shape, {0, -1}, params, acc) do
      {:yes, updated} -> drop(updated, params, next_acc)
      {:no, updated} -> add_shape(updated, next_acc)
    end
  end

  defp move(shape, {dx, dy}, params, acc) do
    # Shape points after applying delta
    c_shape = Enum.map(shape, fn {x, y} -> {x + dx, y + dy} end)
    c_allowed = Enum.all?(c_shape, fn point -> point_allowed?(point, params, acc) end)

    case c_allowed do
      true -> {:yes, c_shape}
      false -> {:no, shape}
    end
  end

  defp point_allowed?(point = {x, y}, %Params{width: w}, acc) when 0 <= x and x < w and 0 < y do
    point not in acc.points
  end

  defp point_allowed?(_point, _params, _acc), do: false

  defp add_shape(shape, acc = %Accumulator{points: acc_points}) do
    new_points = Enum.reduce(shape, acc_points, fn x, points -> MapSet.put(points, x) end)
    shape_y = Enum.map(shape, fn {_x, y} -> y end)
    new_height = Enum.max([acc.height | shape_y])

    %Accumulator{acc | height: new_height, points: new_points}
  end
end

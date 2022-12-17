defmodule Shapes do
  @shape1 [{0, 0}, {1, 0}, {2, 0}, {3, 0}]
  @shape2 [{1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2}]
  @shape3 [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}]
  @shape4 [{0, 0}, {0, 1}, {0, 2}, {0, 3}]
  @shape5 [{0, 0}, {1, 0}, {0, 1}, {1, 1}]

  def shapes() do
    [@shape1, @shape2, @shape3, @shape4, @shape5]
    |> Stream.cycle()
  end
end

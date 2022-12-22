defmodule ParseTest do
  use ExUnit.Case

  test "parse sample" do
    {maze, instructions} = Parse.from("test/sample")
    assert instructions == [10, :right, 5, :left, 5, :right, 10, :left, 4, :right, 5, :left, 5]
    assert length(maze) == 12
  end
end

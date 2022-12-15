defmodule ParseTest do
  use ExUnit.Case

  test "parse" do
    assert Parse.parse("Sensor at x=2, y=18: closest beacon is at x=-2, y=15") ===
             {{2, 18}, {-2, 15}}
  end
end

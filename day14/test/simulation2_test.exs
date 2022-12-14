defmodule Simulation2Test do
  use ExUnit.Case

  defp horizontal(range, y) do
    range
    |> Enum.map(&({&1, y}))
    |> MapSet.new()
  end

  test "last row" do
    actual = Simulation2.last_row(
      MapSet.new([
        {494, 9},
        {495, 9},
        {496, 9},
        {497, 9},
        {498, 9},
        {499, 9},
        {500, 9},
        {501, 9},
        {502, 9},
        {502, 8},
        {502, 7},
        {502, 6},
        {502, 5},
        {502, 4},
        {503, 4},
        {496, 6},
        {497, 6},
        {498, 6},
        {498, 5},
        {498, 4}
      ])
    )
    assert actual === 9
  end

  test "drop on to line" do
    occupied = horizontal(4..6, 4)
    assert Simulation2.drop({5,0}, {5,0}, occupied, 5) == {:rest, {5,3}}
  end

  test "fall to left" do
    occupied = horizontal(3..7, 4)
      |> MapSet.put({5,3})
    assert Simulation2.drop({5,0}, {5,0}, occupied, 5) == {:rest, {4,3}}
  end

  test "fall to right" do
    occupied = horizontal(3..7, 4)
      |> MapSet.put({5,3})
      |> MapSet.put({4,3})
    assert Simulation2.drop({5,0}, {5, 0}, occupied, 5) == {:rest, {6,3}}
  end

  test "fall straight to floor" do
    occupied = MapSet.new([{4,3}, {6,4}])
    assert Simulation2.drop({5,0}, {5,0}, occupied, 6) == {:rest, {5,5}}
  end

  test "fall and roll to floor" do
    occupied = MapSet.new([{5,2}, {3,4}, {4,4}])
    assert Simulation2.drop({5,0}, {5,0}, occupied, 6) == {:rest, {5,5}}
  end

  test "fall to floor left" do
    occupied = MapSet.new([{5,8}])
    assert Simulation2.drop({5,0}, {5,0}, occupied, 9) == {:rest, {4,8}}
  end

  test "fall to floor right" do
    occupied = horizontal(2..4, 6)
    assert Simulation2.drop({4,0}, {4,0}, occupied, 7) == {:rest, {5,6}}
  end

  test "finish when can not fall" do
    occupied = horizontal(0..2, 1)
    assert Simulation2.drop({1,0}, {1,0}, occupied, 3) == {:end, nil}
  end
end

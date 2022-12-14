defmodule Simulation1Test do
  use ExUnit.Case

  defp horizontal(range, y) do
    range
    |> Enum.map(&({&1, y}))
    |> MapSet.new()
  end

  test "last row" do
    actual = Simulation1.last_row(
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
    assert Simulation1.drop({5, 0}, occupied, 5) == {:rest, {5,3}}
  end

  test "fall to left" do
    occupied = horizontal(3..7, 4)
      |> MapSet.put({5,3})
    assert Simulation1.drop({5, 0}, occupied, 5) == {:rest, {4,3}}
  end

  test "fall to right" do
    occupied = horizontal(3..7, 4)
      |> MapSet.put({5,3})
      |> MapSet.put({4,3})
    assert Simulation1.drop({5, 0}, occupied, 5) == {:rest, {6,3}}
  end

  test "fall straight through" do
    occupied = MapSet.new([{4,3}, {6,4}])
    assert Simulation1.drop({5,0}, occupied, 5) == {:end, nil}
  end

  test "fall and roll through" do
    occupied = MapSet.new([{5,2}, {3,4}, {4,4}])
    assert Simulation1.drop({5,0}, occupied, 5) == {:end, nil}
  end
end

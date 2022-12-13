defmodule PacketsTest do
  use ExUnit.Case

  test "simple ordered lists" do
    assert Packets.is_ordered([1,1,3,1,1], [1,1,5,1,1])
  end

  test "mix non-list" do
    assert Packets.is_ordered([[1],[2,3,4]], [[1],4])
  end

  test "mixed type" do
    refute Packets.is_ordered([9], [[8,7,6]])
  end

  test "left shorter, same values" do
    assert Packets.is_ordered([[4,4],4,4], [[4,4],4,4,4])
  end

  test "right shorter, same values" do
    refute Packets.is_ordered([7,7,7,7], [7,7,7])
  end

  test "empty with value" do
    assert Packets.is_ordered([], [3])
  end

  test "left more nested" do
    refute Packets.is_ordered([[[]]], [[]])
  end

  test "diff in deep nest" do
    refute Packets.is_ordered([1,[2,[3,[4,[5,6,7]]]],8,9], [1,[2,[3,[4,[5,6,0]]]],8,9])
  end

  test "test empty lists" do
    assert Packets.is_ordered([], [])
  end

  test "test same lists" do
    assert Packets.is_ordered([1], [1])
  end
end

defmodule ParseTest do
  use ExUnit.Case

  test "simple lists" do
    assert Parse.parsePair(["[1,1,3,1,1]", "[1,1,5,1,1]", ""]) == {
      [1, 1, 3, 1, 1],
      [1, 1, 5, 1, 1]
    }
  end

  test "nested list 1" do
    assert Parse.parsePair(["[[1],[2,3,4]]", "[[1],4]", ""]) == {
      [[1],[2,3,4]],
      [[1],4]
    }
  end

  test "nested list 2" do
    assert Parse.parsePair(["[9]", "[[8,7,6]]"]) == { [9], [[8,7,6]] }
  end

  test "nested list 3" do
    assert Parse.parsePair(["[[4,4],4,4]", "[[4,4],4,4,4]", ""]) == {[[4,4],4,4], [[4,4],4,4,4]}
  end

  test "simple list of 7s" do
    assert Parse.parsePair(["[7,7,7,7]", "[7,7,7]"]) == {[7,7,7,7], [7,7,7]}
  end

  test "empty then single" do
    assert Parse.parsePair(["[]", "[3]"]) == {[], [3]}
  end

  test "nested empty" do
    assert Parse.parsePair(["[[[]]]", "[[]]", ""]) == {[[[]]], [[]]}
  end

  test "harder nested" do
    assert Parse.parsePair(["[1,[2,[3,[4,[5,6,7]]]],8,9]", "[1,[2,[3,[4,[5,6,0]]]],8,9]"]) == {
      [1,[2,[3,[4,[5,6,7]]]],8,9],
      [1,[2,[3,[4,[5,6,0]]]],8,9]
    }
  end

  test "parse with double digits" do
    assert Parse.parsePair(["[1]", "[15]"]) == {[1], [15]}
  end

  test "parse inputs" do
    pairs = File.stream!("input", [:utf8], :line)
      |> Stream.map(&String.trim/1)
      |> Stream.chunk_every(3)
      |> Enum.each(fn entry = [left, right | _]->
        {pLeft, _} = Code.eval_string(left)
        {pRight, _} = Code.eval_string(right)
        assert Parse.parsePair(entry) == {pLeft, pRight}
      end)
  end
end

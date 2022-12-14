defmodule ParseTest do
  use ExUnit.Case

  defp horizontal(range, y) do
    range
    |> Enum.reverse()
    |> Enum.map(&({&1, y}))
  end

  defp vertical(x, range) do
    range
    |> Enum.reverse()
    |> Enum.map(&({x, &1}))
  end

  test "go right" do
    assert Parse.parse("10,50 -> 14, 50") === horizontal(10..14, 50)
  end

  test "go down" do
    assert Parse.parse("72,151 -> 72, 154") === vertical(72, 151..154)
  end

  test "go left" do
    assert Parse.parse("82,23 -> 72,23") === horizontal(82..72, 23)
  end

  test "go up" do
    assert Parse.parse("49,345 -> 49,339") === vertical(49, 345..339)
  end

  test "circle clock wise" do
    assert Parse.parse("32,32 -> 38,32 -> 38,38 -> 32,38 -> 32,33")
      # The lists need to be reversed because of Elixir!
      === vertical(32, 38..33) ++ horizontal(38..33, 38) ++ vertical(38, 32..37) ++  horizontal(32..37, 32)
  end
end

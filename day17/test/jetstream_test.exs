defmodule JetstreamTest do
  use ExUnit.Case

  test "parse line" do
    assert Jetstream.parse("<>><<>") |> Enum.take(12) == [
             -1,
             1,
             1,
             -1,
             -1,
             1,
             -1,
             1,
             1,
             -1,
             -1,
             1
           ]
  end

  test "parse file" do
    stream = Jetstream.from("test/sample")
    assert Enum.take(stream, 12) == [1, 1, 1, -1, -1, 1, -1, 1, 1, -1, -1, -1]
    assert Enum.at(stream, 42) == 1
    assert Enum.at(stream, 46) == -1
  end
end

defmodule Parse do
  defmodule Context do
    defstruct text: "", list: [], counts: [0]
  end

  def parsePair([left, right | _newline]) do
    {parse(left), parse(right)}
  end

  defp parse(content) do
    content
    |> String.graphemes()
    |> do_parse(%Context{})
    |> Enum.at(0)
  end

  defp do_parse(["," | remaining], ctx) do
    do_parse(remaining, flushBuf(ctx))
  end

  defp do_parse([], %Context{list: res}), do: res

  defp do_parse(["]" | remaining], ctx) do
    ctx = %Context{list: list, counts: [count | rCounts]} = flushBuf(ctx)
    {sublist, listEnd} = get_sublists(list, count)
    do_parse(remaining, %{ctx | list: [sublist | listEnd], counts: rCounts})
  end

  defp do_parse(["[" | remaining], ctx) do
    ctx = %Context{counts: [lCount | rCounts]} = flushBuf(ctx)
    do_parse(remaining, %{ctx | counts: [0, lCount + 1 | rCounts]})
  end

  defp do_parse([next | remaining], ctx = %Context{text: pretext}) do
    do_parse(remaining, %{ctx | text: pretext <> next})
  end

  # Nothing to flush
  defp flushBuf(ctx = %Context{text: ""}), do: ctx

  defp flushBuf(ctx = %Context{text: text, list: list, counts: [count | rem]}) do
    value = String.to_integer(text)
    %{ctx | text: "", list: [value | list], counts: [count + 1 | rem]}
  end

  defp get_sublists(list, 0), do: {[], list}

  defp get_sublists(list, count) do
    sublist =
      Enum.slice(list, 0..(count - 1))
      |> Enum.reverse()

    listEnd = Enum.slice(list, count, length(list) - 1)
    {sublist, listEnd}
  end
end

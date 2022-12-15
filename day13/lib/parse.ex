defmodule Parse do
  defmodule Accumulator do
    defstruct text: "", stack: []
  end

  def parsePair([left, right | _newline]) do
    {parse(left), parse(right)}
  end

  defp parse(content) do
    content
    |> String.graphemes()
    |> do_parse(%Accumulator{})
  end

  defp do_parse(["," | remaining], acc) do
    do_parse(remaining, flush_buf(acc))
  end

  defp do_parse([], %Accumulator{stack: [res]}), do: res

  defp do_parse(["]" | remaining], acc) do
    new_acc =
      acc
      |> flush_buf()
      |> gather_list([])

    do_parse(remaining, new_acc)
  end

  defp do_parse(["[" | remaining], acc) do
    new_acc = %Accumulator{stack: stack} = flush_buf(acc)
    do_parse(remaining, %{new_acc | stack: [:list | stack]})
  end

  defp do_parse([next | remaining], acc = %Accumulator{text: pretext}) do
    do_parse(remaining, %{acc | text: pretext <> next})
  end

  # Nothing to flush
  defp flush_buf(acc = %Accumulator{text: ""}), do: acc

  defp flush_buf(acc = %Accumulator{text: text, stack: stack}) do
    value = String.to_integer(text)
    %{acc | text: "", stack: [value | stack]}
  end

  defp gather_list(acc = %Accumulator{stack: [:list | remaining]}, list) do
    %{acc | stack: [list | remaining]}
  end

  defp gather_list(acc = %Accumulator{stack: [elem | remaining]}, list) do
    gather_list(%{acc | stack: remaining}, [elem | list])
  end
end

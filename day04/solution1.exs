defmodule Functions do
  def overlap?([elf1, elf2]) do
    do_overlap?(parse_range(elf1), parse_range(elf2))
  end

  defp parse_range(range) do
    [r_start, r_end] = String.split(range, "-")
    {String.to_integer(r_start), String.to_integer(r_end)}
  end

  defp do_overlap?({start1, end1}, {start2, end2}) when start1 <= start2 and end2 <= end1, do: true
  defp do_overlap?({start1, end1}, {start2, end2}) when start2 <= start1 and end1 <= end2, do: true
  defp do_overlap?(_elf1, _elf2), do: false
end

File.stream!("input", [:utf8], :line)
|> Stream.map(&String.trim/1)
|> Stream.map(&(String.split(&1, ",")))
|> Enum.count(&Functions.overlap?/1)
|> IO.inspect(label: "Count")

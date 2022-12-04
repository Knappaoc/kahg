defmodule Functions do
  def disjoint?([elf1, elf2]) do
    do_disjoint?(parse_range(elf1), parse_range(elf2))
  end

  defp parse_range(range) do
    [r_start, r_end] = String.split(range, "-")
    {String.to_integer(r_start), String.to_integer(r_end)}
  end

  # Elf 1 range < Elf 2 range
  defp do_disjoint?({start1, end1}, {start2, _end2}) when start1 < start2 and end1 < start2, do: true
  # Elf 2 range < Elf 1 range
  defp do_disjoint?({start1, end1}, {_start2, end2}) when start1 > end2 and end1 > end2, do: true
  # Anything else, there is overlap
  defp do_disjoint?(_elf1, _elf2), do: false
end

File.stream!("input", [:utf8], :line)
|> Stream.map(&String.trim/1)
|> Stream.map(&(String.split(&1, ",")))
|> Stream.reject(&Functions.disjoint?/1)
|> Enum.count()
|> IO.inspect(label: "Count")

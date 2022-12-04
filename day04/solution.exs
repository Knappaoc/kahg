defmodule Functions do
  def parse_pairs([elf1, elf2]), do: {parse_range(elf1), parse_range(elf2)}

  defp parse_range(range) do
    [r_start, r_end] = String.split(range, "-")
    {String.to_integer(r_start), String.to_integer(r_end)}
  end

  @doc """
  Returns true if one range is wholly inside the other
  """
  def overlap?({{start1, end1}, {start2, end2}}) when start1 <= start2 and end2 <= end1, do: true
  def overlap?({{start1, end1}, {start2, end2}}) when start2 <= start1 and end1 <= end2, do: true
  def overlap?({_elf1, _elf2}), do: false

  @doc """
  Returns true if the sets DON'T overlap
  """
  # Elf 1 range < Elf 2 range
  def disjoint?({{start1, end1}, {start2, _end2}}) when start1 < start2 and end1 < start2, do: true
  # Elf 2 range < Elf 1 range
  def disjoint?({{start1, end1}, {_start2, end2}}) when start1 > end2 and end1 > end2, do: true
  # Anything else, there is overlap
  def disjoint?({_elf1, _elf2}), do: false
end

pairs = File.stream!("input", [:utf8], :line)
|> Stream.map(&String.trim/1)
|> Stream.map(&(String.split(&1, ",")))
|> Stream.map(&Functions.parse_pairs/1)
|> Enum.into([])

# Part 1 - Count of pairs where one pair is wholly inside the other
pairs
|> Enum.count(&Functions.overlap?/1)
|> IO.inspect(label: "Count of whole overlap")

# Part 2 - Count of pairs with ANY overlap (or things that DON'T have NO OVERLAP)
pairs
|> Enum.reject(&Functions.disjoint?/1)
|> Enum.count()
|> IO.inspect(label: "Count of any overlap")

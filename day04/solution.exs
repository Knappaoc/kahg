defmodule Functions do
  def parse_pairs([elf1, elf2]), do: {parse_range(elf1), parse_range(elf2)}

  defp parse_range(range) do
    [r_start, r_end] = String.split(range, "-")
    String.to_integer(r_start)..String.to_integer(r_end)
  end

  @doc """
  Returns true if one range is wholly inside the other
  """
  def overlap?({elf1, elf2}) do
    Enum.all?(elf1, fn x -> x in elf2 end) || Enum.all?(elf2, fn x -> x in elf1 end)
  end
end

pairs = File.stream!("input", [:utf8], :line)
|> Stream.map(&String.trim/1)
|> Stream.map(&(String.split(&1, ",")))
|> Enum.map(&Functions.parse_pairs/1)

# Part 1 - Count of pairs where one pair is wholly inside the other
pairs
|> Enum.count(&Functions.overlap?/1)
|> IO.inspect(label: "Count of whole overlap")

# Part 2 - Count of pairs with ANY overlap (or things that DON'T have NO OVERLAP)
pairs
|> Enum.reject(fn {elf1, elf2} -> Range.disjoint?(elf1, elf2) end)
|> Enum.count()
|> IO.inspect(label: "Count of any overlap")

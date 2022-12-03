defmodule Functions do
  @doc """
  Receives each entry and accumulates the total calories for
  each elf. A nil value represents a new elf is expected.
  """
  def calc_cals("", {sum, acc}), do: {nil, add_to(sum, acc)}

  def calc_cals(value, context) when is_binary(value) do
    value
    |> String.trim()
    |> String.to_integer()
    |> calc_cals(context)
  end

  def calc_cals(value, {nil, acc}), do: {value, acc}
  def calc_cals(value, {sum, acc}), do: {value + sum, acc}

  @doc """
  Adds a new value to the accumulator, as long as it isn't nil.
  """
  def add_to(nil, acc), do: acc
  def add_to(value, acc), do: [value | acc]
end

# Stream each line in the file and collect the total calories.
{last, acc} = File.stream!("inputs", [:utf8], :line)
  |> Stream.map(&String.trim/1)
  |> Enum.reduce({nil, []}, &Functions.calc_cals/2)

# Interested in, at most, the 3 highest totals.
{top, _} = Functions.add_to(last, acc)
  |> Enum.sort(:desc)
  |> Enum.split(3)

# Part 1: What is the highest total?
top
  |> Enum.at(0)
  |> IO.inspect(label: "Highest")

# Part 2: What is the sum of the 3 highest?
top
  |> Enum.reduce(0, &(&1 + &2))
  |> IO.inspect(label: "Top 3 sum")

defmodule Functions do
  @loss 0
  @draw 1
  @win 2

  def decode(value) do
    value
    |> String.to_charlist()
    |> List.first()
  end

  def score([theirs, outcome], acc) do
    d_theirs = decode(theirs) - ?A
    d_outcome = decode(outcome) - ?X
    3 * (d_outcome) + score_choice(d_theirs, d_outcome) + 1 + acc
  end

  # This works based on rock < paper < scissors
  #   rock 0
  #   paper 1
  #   scissors 2
  def score_choice(theirs, outcome)
  def score_choice(theirs, @draw), do: theirs
  def score_choice(theirs, @win) do
    # In this case, the points is the "next one up"
    rem(theirs + 1, 3)
  end
  def score_choice(theirs, @loss) do
    # The first part is from: theirs - 1 + 3 = theirs + 2
    rem(theirs + 2, 3)
  end
end

File.stream!("inputs", [:utf8], :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split/1)
  |> Enum.reduce(0, &Functions.score/2)
  |> IO.inspect(label: "Score")

defmodule Functions do
  @rock 0
  # @paper 1   (not used anywhere)
  @scissors 2

  def decode(value) do
    value
    |> String.to_charlist()
    |> List.first()
  end

  def score([theirs, mine], acc) do
    d_theirs = decode(theirs) - ?A
    d_mine = decode(mine) - ?X
    score_outcome(d_theirs, d_mine) + d_mine + 1 + acc
  end

  # Draws - when their choice is the same as mine
  def score_outcome(theirs, theirs), do: 3

  # Wins
  # First case captures paper beats rock and scissors beats paper
  def score_outcome(theirs, mine) when theirs + 1 == mine, do: 6
  def score_outcome(@scissors, @rock), do: 6

  # Rest of cases are losses
  def score_outcome(_theirs, _mine), do: 0
end

File.stream!("inputs", [:utf8], :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split/1)
  |> Enum.reduce(0, &Functions.score/2)
  |> IO.inspect(label: "Score")

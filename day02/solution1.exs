defmodule Functions do
  def score([opp, me], acc) do
    opp_atom = String.to_atom(opp)
    me_atom = String.to_atom(me)
    score_outcome(opp_atom, me_atom) + score_choice(me_atom) + acc
  end

  # Opp rock
  # Rock - Rock
  def score_outcome(:A, :X), do: 3
  # Rock - Paper
  def score_outcome(:A, :Y), do: 6
  # Rock - Scissors
  def score_outcome(:A, :Z), do: 0

  # Opp paper
  # Paper - Rock
  def score_outcome(:B, :X), do: 0
  # Paper - Paper
  def score_outcome(:B, :Y), do: 3
  # Paper - Scissors
  def score_outcome(:B, :Z), do: 6

  # Opp scissors
  # Scissors - Rock
  def score_outcome(:C, :X), do: 6
  # Scissors - Paper
  def score_outcome(:C, :Y), do: 0
  # Scissors - Scissors
  def score_outcome(:C, :Z), do: 3

  def score_choice(:X), do: 1
  def score_choice(:Y), do: 2
  def score_choice(:Z), do: 3
end

File.stream!("inputs", [:utf8], :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split/1)
  |> Enum.reduce(0, &Functions.score/2)
  |> IO.inspect(label: "Score")

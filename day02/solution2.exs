defmodule Functions do
  def score([opp, outcome], acc) do
    opp_atom = String.to_atom(opp)
    outcome_atom = String.to_atom(outcome)
    score_outcome(outcome_atom) + score_choice(opp_atom, outcome_atom) + acc
  end

  # Lose
  def score_outcome(:X), do: 0
  # Draw
  def score_outcome(:Y), do: 3
  # Win
  def score_outcome(:Z), do: 6

  # Opp rock
  # Rock - Lose - Have to give scissors
  def score_choice(:A, :X), do: 3
  # Rock - Draw - Have to give rock
  def score_choice(:A, :Y), do: 1
  # Rock - win - Have to give paper
  def score_choice(:A, :Z), do: 2

  # Opp paper
  # Paper - Lose - Have to give rock
  def score_choice(:B, :X), do: 1
  # Paper - Draw - Have to give paper
  def score_choice(:B, :Y), do: 2
  # Paper - Win - Have to give scissors
  def score_choice(:B, :Z), do: 3

  # Opp scissors
  # Scissors - Lose - Have to give paper
  def score_choice(:C, :X), do: 2
  # Scissors - Draw - Have to give scissors
  def score_choice(:C, :Y), do: 3
  # Scissors - Win - Have to give rock
  def score_choice(:C, :Z), do: 1
end

File.stream!("inputs", [:utf8], :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split/1)
  |> Enum.reduce(0, &Functions.score/2)
  |> IO.inspect(label: "Score")

defmodule Puzzle2 do
  def solve(monkeys) do
    {r_left, _op, r_right} = Map.get(monkeys, "root").piece
    IO.inspect({r_left, r_right}, label: "monkeys")

    # Step 1 - we need to figure out which side we can work on.
    # Root should have two pieces. Might be easier to do one side at a time.
    # Assumption is that the root isn't directly on humn.
    r_left_monkey = Map.get(monkeys, r_left)
    r_right_monkey = Map.get(monkeys, r_right)

    # Step 2 - One side is :human, the other side is the value.
    r_left_value = do_solve(monkeys, r_left_monkey)
    r_right_value = do_solve(monkeys, r_right_monkey)

    {value, _value_monkey, human} =
      humanise({r_left_value, r_left_monkey}, {r_right_value, r_right_monkey})

    # Step 3 - Solve the human side!
    rev_solve(monkeys, human, value)
  end

  def rev_solve(monkeys, %Monkey{piece: {"humn", op, right}}, target) do
    right_value = do_solve(monkeys, Map.get(monkeys, right))

    # We know the right hand value.
    rev_target(:human, op, right_value, target)
  end

  def rev_solve(monkeys, %Monkey{piece: {left, op, "humn"}}, target) do
    left_value = do_solve(monkeys, Map.get(monkeys, left))

    # We know the left hand value.
    rev_target(left_value, op, :human, target)
  end

  def rev_solve(monkeys, %Monkey{piece: {left, op, right}}, target) do
    # Step 1 - Try solving both sides and work out which monkey is the "human" and which is solvable.
    left_monkey = Map.get(monkeys, left)
    right_monkey = Map.get(monkeys, right)

    left_value = do_solve(monkeys, left_monkey)
    right_value = do_solve(monkeys, right_monkey)

    # Step 2 - What is the new target?
    new_target = rev_target(left_value, op, right_value, target)

    # Step 3 - Recurse to solve the "human" side.
    {_value, _value_monkey, human} =
      humanise({left_value, left_monkey}, {right_value, right_monkey})

    rev_solve(monkeys, human, new_target)
  end

  def rev_target(left_value, "*", :human, target), do: div(target, left_value)
  def rev_target(left_value, "/", :human, target), do: div(left_value, target)
  def rev_target(left_value, "+", :human, target), do: target - left_value
  def rev_target(left_value, "-", :human, target), do: left_value - target
  def rev_target(:human, "*", right_value, target), do: div(target, right_value)
  def rev_target(:human, "/", right_value, target), do: target * right_value
  def rev_target(:human, "+", right_value, target), do: target - right_value
  def rev_target(:human, "-", right_value, target), do: target + right_value

  def non_human_piece(%Monkey{piece: {left, _op, %Monkey{id: "humn"}}}), do: {left, :right}
  def non_human_piece(%Monkey{piece: {%Monkey{id: "humn"}, _op, right}}), do: {right, :left}

  @doc """
  This is a convenience function to consistently distinguish between a "solved" monkey side and the "human" monkey.
  The arguments are the two monkeys, given as a tuple {value, monkey} (where value is the solved value or :human if it is a human monkey).
  Returns a tuple consisting of {solved value, solved monkey, human monkey}.
  """
  def humanise({left, left_monkey}, {:human, right_monkey}), do: {left, left_monkey, right_monkey}
  def humanise({:human, left_monkey}, {right, right_monkey}),
    do: {right, right_monkey, left_monkey}

  def do_solve(_monkeys, %Monkey{piece: n}) when is_integer(n), do: n

  def do_solve(_monkeys, %Monkey{piece: {left, _op, right}})
      when left == "humn" or right == "humn",
      do: :human

  def do_solve(monkeys, %Monkey{piece: {left, op, right}}) do
    left_monkey = Map.get(monkeys, left)
    right_monkey = Map.get(monkeys, right)

    with left_value when left_value != :human <- do_solve(monkeys, left_monkey),
      right_value when right_value != :human <- do_solve(monkeys, right_monkey)
    do
      op(left_value, op, right_value)
    else
      _ -> :human
    end
  end

  def op(left, "+", right), do: left + right
  def op(left, "-", right), do: left - right
  def op(left, "*", right), do: left * right
  def op(left, "/", right), do: div(left, right)
end

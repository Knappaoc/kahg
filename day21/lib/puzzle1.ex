defmodule Puzzle1 do
  def solve(monkeys) do
    # Start at root
    do_solve(monkeys, Map.get(monkeys, "root"))
  end

  def do_solve(_monkeys, %Monkey{piece: n}) when is_integer(n), do: n

  def do_solve(monkeys, %Monkey{piece: {left, op, right}}) do
    left_v = Map.get(monkeys, left)
    right_v = Map.get(monkeys, right)

    op(do_solve(monkeys, left_v), op, do_solve(monkeys, right_v))
  end

  def op(left, "+", right), do: left + right
  def op(left, "-", right), do: left - right
  def op(left, "*", right), do: left * right
  def op(left, "/", right), do: div(left, right)
end

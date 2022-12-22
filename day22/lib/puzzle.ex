defmodule Puzzle do
  def solve(maze, instruct) do
    IO.inspect(instruct, label: "instructions")

    # Step 1 - find the starting position
    start = find_start(maze, 0)
    |> IO.inspect(label: "start")

    %Accumulator{position: {x, y}, direction: direction} = execute(maze, instruct, %Accumulator{direction: {1, 0}, position: start})
    IO.inspect(x, label: "x")
    IO.inspect(y, label: "y")
    IO.inspect(direct_score(direction), label: "direction")
    score = (y + 1) * 1000 + (x + 1) * 4 + direct_score(direction)
    IO.inspect(score, label: "Part 1")
  end

  def direct_score({1, 0}), do: 0
  def direct_score({0, 1}), do: 1
  def direct_score({-1, 0}), do: 2
  def direct_score({0, -1}), do: 3

  def find_start([row | others], row_no) do
    case Enum.find_index(row, fn c -> c == "." end) do
      n when n != nil -> {n, row_no}
      nil -> find_start(others, row_no + 1)
    end
  end

  # End condition - no more instructions
  def execute(_maze, [], acc=%Accumulator{}), do: acc

  # Turn left
  def execute(maze, [:left | remaining], acc=%Accumulator{direction: {dx, dy}}) do
    IO.puts("Turn left")
    execute(maze, remaining, %Accumulator{acc | direction: {dy, -dx}})
  end
  # Turn right
  def execute(maze, [:right | remaining], acc=%Accumulator{direction: {dx, dy}}) do
    IO.puts("Turn right")
    execute(maze, remaining, %Accumulator{acc | direction: {-dy, dx}})
  end

  # Move forward in direction
  def execute(maze, [next | remaining], acc) when is_integer(next) do
    IO.puts("Move #{next} from #{acc.position}")
    new_acc = do_move(maze, next, acc)
    execute(maze, remaining, new_acc)
  end

  def do_move(maze, times, acc) do
    case step_forward(maze, acc) do
      {:cont, new_acc} -> do_move(maze, times - 1, new_acc)
      {:stop, new_acc} -> new_acc
    end
  end

  # Does one step forward in the current direction.
  def step_forward(maze, acc = %Accumulator{position: {x, y}, direction: {dx, dy}}) do
    # Step 1: What would be the next position if we move there?
    cy = wrap_dim(maze, y+dy)
    row = Enum.at(maze, cy)
    # IO.inspect(row, label: "  row")
    cx = wrap_dim(row, x+dx)
    char = Enum.at(row, cx)
    # IO.inspect(cx, label: "  wrapped x")
    # IO.inspect(char, label: "  char")

    # Step 2: What is the character on that row?
    case char do
      " " -> step_forward(maze, %Accumulator{acc | position: {cx, cy}})
      "#" -> {:stop, acc}
      "." -> {:cont, %Accumulator{acc | position: {cx, cy}}}
    end
  end

  def wrap_dim(slice, i) when 0 <= i and i < length(slice), do: i
  def wrap_dim(slice, i) when i < 0, do: rem(i, length(slice)) + length(slice)
  def wrap_dim(slice, i), do: rem(i, length(slice))
end

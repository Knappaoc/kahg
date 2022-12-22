{maze, instructions} = Parse.from("sample")
IO.inspect(length(maze), label: "maze rows")
Puzzle.solve(maze, instructions)

# This algorithm works by converting choices to:
#   rock = 0
#   paper = 1
#   scissors = 2
#
# And outcome to:
#   loss = 0
#   draw = 1
#   win = 2
open("inputs", "r") do file
  part1, part2 = 0, 0
  while !eof(file)
    (theirs, right) = split(readline(file))

    # Convert "theirs"
    theirs = Char(theirs[1]) - Char('A')

    # Convert right to numerical value
    right = Char(right[1]) - Char('X')

    # For part 1, treating right as our choice,
    # we "win" if our choice is the "next one up"
    # and "lose" if our choice is the "one before"...
    part1 = part1 + (right + 1) + 3*((right - theirs + 4) % 3)

    # For part 2, we get back to our choice by moving
    # back up or down depending on outcome
    part2 = part2 + right * 3 + ((right - 1 + theirs + 3) % 3) + 1
  end
  println("part 1 score: $part1")
  println("part 2 score: $part2")
end;
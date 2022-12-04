function score(c::Char)
  if 'a' <= c && c <= 'z'
    return c - 'a' + 1
  end
  return c - 'A' + 27
end

open("input", "r") do file
  total = 0
  while !eof(file)
    common = intersect(readline(file), readline(file), readline(file))
    total += reduce(sum, map(score, common))
  end
  println("Total: $total")
end;

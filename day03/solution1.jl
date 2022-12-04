function score(c::Char)
  if 'a' <= c && c <= 'z'
    return c - 'a' + 1
  end
  return c - 'A' + 27
end

open("input", "r") do file
  total = 0
  while !eof(file)
    line = readline(file)
    halfway = Int64(lastindex(line) / 2)
    common = intersect(line[1:halfway], line[halfway+ 1: end])
    scores = map(score, common)
    total += reduce(sum, scores)
  end
  println("Total: $total")
end;

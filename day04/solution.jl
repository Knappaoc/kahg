function parsePairs(pair)
  (elf1, elf2) = split(pair, ",")
  return (parseRange(elf1), parseRange(elf2))
end

function parseRange(elf)
  (rStart, rEnd) = split(elf, "-")
  return parse(Int64, rStart):parse(Int64, rEnd)
end

open("input", "r") do file
  countSubset = 0
  anyOverlap = 0
  while !eof(file)
    line = readline(file)
    (elf1, elf2) = parsePairs(line)
    common = intersect(elf1, elf2)
    if elf1 == common || elf2 == common
      countSubset += 1
    end
    if !isempty(common)
      anyOverlap += 1
    end
  end
  println("subset count: $countSubset")
  println("any overlap count: $anyOverlap")
end;
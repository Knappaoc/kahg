COLUMN_WIDTH = 4

function readStartMap(file)
  buffer = []
  line = readline(file)
  columnCount = getColumnCount(line)
  
  while !eof(file) && columnCount < 0
    push!(buffer, line)
    line = readline(file)
    columnCount = getColumnCount(line)
  end

  startMap = fill("", columnCount)
  for content in buffer
    for i = 1:columnCount
      crate = content[(i - 1)*COLUMN_WIDTH+2]
      if crate != ' ' 
        startMap[i] = string(crate, startMap[i])
      end
    end
  end

  return startMap
end

function getColumnCount(content::String)
  fields = split(content)
  if all(isNumber(string(f)) for f in fields)
    return length(fields)
  end
  return -1
end

function isNumber(content::String)
  try 
    parse(Int, content)
  catch ArgumentError
    return false
  end
  return true
end

function apply!(stacks, n, src, dest, order)
  stacks[dest] = string(stacks[dest], order(string(stacks[src][end-n+1:end])))
  if length(stacks[src]) == n 
    stacks[src] = ""
  else
    stacks[src] = stacks[src][1:end-n]
  end
end

open("input", "r") do file
  crane1 = readStartMap(file)
  crane2 = copy(crane1)

  f(x) = x
  while !eof(file)
    instruction = split(readline(file))
    if length(instruction) > 0
      n = parse(Int, instruction[2])
      src = parse(Int, instruction[4])
      dest = parse(Int, instruction[6])

      apply!(crane1, n, src, dest, reverse)
      apply!(crane2, n, src, dest, f)
    end
  end

  println("Crane 9000: $crane1")
  println("Crane 9001: $crane2")
end;
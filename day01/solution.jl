function next(file)::Vector{UInt32}
  content::Vector{UInt32}=[]
  while (line = readline(file)) != "" && !eof(file)
    push!(content, parse(UInt32, line))
  end
  return content
end

calories::Vector{UInt32}=[]
open("inputs", "r") do file
  while !eof(file)
    entries = next(file)
    if !isempty(entries)
      push!(calories, reduce(+, entries))
    end
  end
end;

calories = sort(calories, rev=true)
println(string("Highest: ", calories[1]))

top3sum=reduce(+, calories[1:3])
println(string("Sum of top 3: ", top3sum))
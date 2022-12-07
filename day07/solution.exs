defmodule Parse do

  @doc """
  Group lines into instructions.
  """
  def chunkInstructions(line, command)

  # First line parsed
  def chunkInstructions(["$" | command], {"", []}), do: {:cont, {command , []}}

  # We have content and a new instruction.
  def chunkInstructions(["$" | command], acc), do: {:cont, acc, {command, []}}

  # For other stuff, it is the part of the current command.
  def chunkInstructions(content, {command, context}), do: {:cont, {command, [ content | context]}}

  def play(command, accumulator)

  # Go back to root doesn't change anything
  def play({["cd", "/"], _stdout}, {_cwd, structure, sizes}), do: {["/"], structure, sizes}

  # Go up a level ... but from root? Not allowed ...
  def play({["cd", ".."], _stdout}, acc = {["/"], _structure, _sizes}), do: acc

  # Go back up a level
  def play({["cd", ".."], _stdout}, {[_dir | parent], structure, sizes}), do: {parent, structure, sizes}

  # Go down a level
  def play({["cd", dir], _stdout}, {cwd, structure, sizes}), do: {[dir | cwd], structure, sizes}

  # Process listing
  def play({["ls"], stdout}, {cwd, structure, sizes}) do
    {size, subdirs} = stdout
      |> Enum.reduce({0, []}, fn elem, acc -> parse_ls(elem, acc) end)

    {cwd, Map.put(structure, cwd, subdirs),  Map.put(sizes, cwd, size)}
  end

  # Parse the output from ls.
  defp parse_ls(elem, acc)
  defp parse_ls(["dir", name], {size, subdirs}), do: {size, [name | subdirs]}
  defp parse_ls([file_size, _file], {dir_size, subdirs}) do
    {dir_size + String.to_integer(file_size), subdirs}
  end
end

defmodule Directories do
  @doc """
  Calculate directory total sizes.
  """
  def calc_sizes(cwd, structure, dir_sizes) do
    {c_total, c_map} = structure[cwd]
    |> Stream.map(fn subdir -> calc_sizes([subdir | cwd], structure, dir_sizes) end)
    |> Enum.reduce({0, %{}}, fn {e_total, e_map}, {a_total, a_map} -> {e_total + a_total, Map.merge(e_map, a_map)} end)

    dir_size = dir_sizes[cwd] + c_total
    {dir_size, Map.put(c_map, cwd, dir_size)}
  end
end

{_cwd, structure, sizes} = File.stream!("input", [:utf8], :line)
|> Stream.map(&String.split/1)
|> Stream.chunk_while({"", []}, &Parse.chunkInstructions/2, fn x -> {:cont, x, []} end)
|> Enum.reduce({[], %{}, %{}}, &Parse.play/2)
|> IO.inspect(label: "{cwd, structure, initial sizes}")

{_last_cwd, dir_sizes} = Directories.calc_sizes(["/"], structure, sizes)
|> IO.inspect(label: "{last_cwd, dir_sizes}")

# Part 1: Total size of directories under 100000
dir_sizes
|> Map.values()
|> Stream.filter(&(&1 <= 100000))
|> Enum.reduce(&(&1 + &2))
|> IO.inspect(label: "Part 1")

# Part 2: Find how much space we need to clear
# Step 1 - Work out how much space we need to clear, noting "/" is the total size
req_min = dir_sizes[["/"]] - (70000000 - 30000000)
# Step 2 - Find the smallest directory that is bigger than this requirement
dir_sizes
|> Map.values()
|> Enum.filter(&(&1 >= req_min))
|> Enum.min()
|> IO.inspect(label: "Part 2")

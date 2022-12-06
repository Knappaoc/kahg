defmodule Parse do
  @colWidth 4

  def chunkSections("", acc), do: {:cont, acc}

  def chunkSections(line, acc) do
    tokens = line
      |> String.trim()
      |> String.split(~r/\s/, trim: true)

    if length(tokens) > 0 do
      label? = Enum.all?(tokens, fn s -> String.match?(s, ~r/^\d+$/) end)

      case label? do
        true -> {:cont, {length(tokens), acc}, []}
        false -> {:cont, [line | acc]}
      end
    else
      {:cont, acc}
    end
  end

  def parseMap({columns, content}) do
    0..columns-1
    |> Enum.map(fn i -> readColumn(i, content) end)
    |> Enum.into([])
  end

  defp readColumn(column, content) do
    content
    |> Enum.map(fn i -> String.at(i, column * @colWidth + 1) end)
    |> Enum.reject(fn c -> c == " " end)
    |> Enum.reverse()
  end

  def parseInstruct(instruct) do
    [_move, n, _from, src, _to, dest] = instruct
    |> String.split()
    {String.to_integer(n), String.to_integer(src) - 1, String.to_integer(dest) - 1}
  end
end

defmodule Move do
  def perform(start, instructions, func) do
    instructions
    |> Enum.reduce(start, fn (instruct, stack) -> do_move(instruct, stack, func) end)
  end

  defp do_move({n, src, dest}, stack, func) do
    moving = stack
      |> Enum.at(src)
      |> Enum.slice(0..n-1)

    stack
    |> List.update_at(dest, fn s -> func.(moving) ++ s end)
    |> List.update_at(src, fn s-> Enum.slice(s, n..length(s) - 1) end)
  end
end

[map, rev_instructions] = File.stream!("input", [:utf8], :line)
|> Stream.chunk_while([], &Parse.chunkSections/2, fn x -> {:cont, x, []} end)
|> Enum.into([])

start = map
  |> Parse.parseMap()
  |> IO.inspect(label: "start")

instructions = rev_instructions
  |> Enum.map(&Parse.parseInstruct/1)
  |> Enum.reverse()

start
|> Move.perform(instructions, &Enum.reverse/1)
|> IO.inspect(label: "Crane 9000")
|> Enum.map(fn x -> Enum.at(x, 0, " ") end)
|> IO.inspect(label: "          ")

start
|> Move.perform(instructions, &(&1))
|> IO.inspect(label: "Crane 9001")
|> Enum.map(fn x -> Enum.at(x, 0, " ") end)
|> IO.inspect(label: "          ")

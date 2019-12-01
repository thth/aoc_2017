defmodule Twentyfive do
  def one(input) do
    start_state = Regex.run(~r/Begin in state (\w)/, input, capture: :all_but_first) |> List.first
    checksum_after = Regex.run(~r/checksum after (\d+)/, input, capture: :all_but_first) |> List.first |> String.to_integer
    ins_map = create_ins_map(input)
    checksum(ins_map, checksum_after, start_state)
  end

  def checksum(ins_map, checksum_after, state, tape \\ MapSet.new, i \\ 0)
  def checksum(_, 0, _, tape, _), do: tape |> MapSet.size
  def checksum(ins_map, checksum_after, state, tape, i) do
    cur = if MapSet.member?(tape, i), do: 1, else: 0
    [write,dir,next_state] = ins_map[state][cur]
    new_tape = if write == 1, do: MapSet.put(tape, i), else: MapSet.delete(tape, i)
    case dir do
      "left" -> checksum(ins_map, checksum_after - 1, next_state, new_tape, i - 1)
      "right" -> checksum(ins_map, checksum_after - 1, next_state, new_tape, i + 1)
    end
  end

  def create_ins_map(input) do
    input
    |> String.split("\n\n")
    |> List.delete_at(0)
    |> Enum.reduce(%{},
      fn (s, m) ->
        Map.put(m,
                Regex.run(~r/In state (\w)/,s, capture: :all_but_first) |> List.first,
                %{
                  0 => Regex.run(~r/is 0.+\n.+(0|1).+\n.+the (\w+).+\n.+state (\w)/, s, capture: :all_but_first) |> List.update_at(0, &String.to_integer/1), # can convert binary str to int here
                  1 => Regex.run(~r/is 1.+\n.+(0|1).+\n.+the (\w+).+\n.+state (\w)/, s, capture: :all_but_first) |> List.update_at(0, &String.to_integer/1),
                  })
      end)
  end
end

input = File.read!("./source/25.txt")
Twentyfive.one(input)
# Twentyfive.two(input)
|> IO.inspect
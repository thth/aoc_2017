raw = File.read!("./source/05.txt")
source = raw |> String.split("\n", trim: true) |> Enum.map(&String.to_integer(&1))
array = :array.from_list(source)
length = Enum.count(source)

defmodule Five do
  @length length
  def one(list, index, step \\ 0) do
    if index < 0 || index >= @length do
      step
    else
      # v = Enum.at(list, index)
      v = :array.get(index, list)
      # new_list = list |> List.replace_at(index, v + 1)
      new_list = :array.set(index, v + 1, list)
      new_index = index + v
      one(new_list, new_index, step + 1)
    end
  end

  def two(list, index, step \\ 0) do
    if index < 0 || index >= @length do
      step
    else
      # v = Enum.at(list, index)
      v = :array.get(index, list)
      change = if v > 2, do: -1, else: 1
      # new_list = list |> List.replace_at(index, v + change)
      new_list = :array.set(index, v + change, list)
      new_index = index + v
      two(new_list, new_index, step + 1)
    end
  end
end
# IO.inspect(Five.one(source, 0))
IO.inspect(Five.one(array, 0))
# IO.inspect(Five.two(source, 0))
IO.inspect(Five.two(array, 0))
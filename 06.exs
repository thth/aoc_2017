raw = File.read!("./source/06.txt")
source = raw |> String.split(~r/\s|\t/, trim: true) |> Enum.map(&String.to_integer/1)

defmodule Six do
  def one(list, seen, count \\ 0) do
    if Enum.any?(seen, &(&1 == list)) do
      count
    else
      v = Enum.max(list)
      i = Enum.find_index(list, &(&1 == v))
      new_list = redistribute(list, i)
      seen = [list] ++ seen
      one(new_list, seen, count + 1)
    end
  end

  defp redistribute(list, i) do
    blocks = Enum.at(list, i)
    new = List.replace_at(list, i, 0)
    start_index = if i == 15, do: 0, else: i + 1
    re(new, blocks, start_index)
  end

  defp re(list, blocks, i) do
    if blocks <= 0 do
      list
    else
      val = Enum.at(list, i)
      next_list = List.replace_at(list, i, val + 1)
      next_index = if i == 15, do: 0, else: i + 1
      re(next_list, blocks - 1, next_index)
    end
  end

  def two(list, seen, count \\ 0) do
    if Enum.any?(seen, &(&1 == list)) do
      curious(list, list, 0)
    else
      v = Enum.max(list)
      i = Enum.find_index(list, &(&1 == v))
      new_list = redistribute(list, i)
      seen = [list] ++ seen
      two(new_list, seen, count + 1)
    end
  end

  defp curious(base, list, count) do
    if base == list && count != 0 do
      count
    else
      v = Enum.max(list)
      i = Enum.find_index(list, &(&1 == v))
      next = redistribute(list, i)
      curious(base, next, count + 1)
    end
  end
end
IO.inspect(Six.one(source,[]))
IO.inspect(Six.two(source,[]))
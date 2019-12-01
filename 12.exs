defmodule Twelve do
  def one(raw) do
    map = process_raw(raw)
    Enum.count(populate_group(map,"0",[],[]))
  end

  def two(raw) do
    map = process_raw(raw)
    count_groups(map,[],0)
  end
  
  def process_raw(raw) do
    r = ~r/\d+/
    raw
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.scan(r,&1))
    |> Enum.map(&lists_to_tuple/1)
    |> Enum.into(%{})
  end

  def lists_to_tuple(list) do
    [k|v] = Enum.map(list, &List.to_string/1)
    {k,v}
  end

  def populate_group(map, origin, in_group, searched) do
    in_group = Enum.uniq(in_group ++ [origin])
    searched = Enum.uniq(searched)
    if searched != [] && in_group -- searched == [] do
      in_group
    else
      keys_to_search = in_group -- searched
      new_searched = searched ++ keys_to_search
      found_nodes = keys_to_search |> Enum.map(&map[&1]) |> Enum.reduce(&(&1 ++ &2))
      new_group = in_group ++ found_nodes
      populate_group(map,origin,new_group,new_searched)
    end
  end

  def count_groups(map, counted, count) do
    if Map.keys(map) -- counted == [] do
      count
    else
      if counted == [] do
        count_groups(map, counted ++ populate_group(map,"0",[],[]), count + 1)
      else
        next_origin = List.first(Map.keys(map) -- counted)
        count_groups(map, counted ++ populate_group(map,next_origin,[],[]), count + 1)
      end
    end
  end
end

raw = File.read!("./source/12.txt")
IO.inspect(Twelve.one(raw))
IO.inspect(Twelve.two(raw))
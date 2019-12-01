defmodule Eleven do
  require Integer

  def one(raw) do
    list = raw |> String.trim() |> String.split(",", trim: true)
    {coords,_} = pos(list,{0,0},0)
    distance(coords)
  end

  def two(raw) do
    list = raw |> String.trim() |> String.split(",", trim: true)
    {coords,prev_max} = pos(list,{0,0},0)
    max(distance(coords),prev_max)
  end

  def pos([],coordinate,max_distance), do: {coordinate, max_distance}
  def pos([h|t],{x,y},max_distance) do
    m = if distance({x,y}) > max_distance, do: distance({x,y}), else: max_distance
    case h do
      "n" -> pos(t,{x,y+1},m)
      "ne" -> if Integer.is_even(x), do: pos(t,{x+1,y},m), else: pos(t,{x+1,y+1},m)
      "se" -> if Integer.is_even(x), do: pos(t,{x+1,y-1},m), else: pos(t,{x+1,y},m)
      "s" -> pos(t,{x,y-1},m)
      "sw" -> if Integer.is_even(x), do: pos(t,{x-1,y-1},m), else: pos(t,{x-1,y},m)
      "nw" -> if Integer.is_even(x), do: pos(t,{x-1,y},m), else: pos(t,{x-1,y+1},m)
      _ -> raise {h,t,{x,y},m}
    end
  end

  def distance({x,y}) do
    if Float.floor(abs(x)/2) >= abs(y) do
      abs(x)
    else
      if y >= 0 do
        abs(x) + y - Float.floor(abs(x)/2)
      else
        abs(x) + abs(y) - Float.ceil(abs(x)/2)
      end
    end
  end
end

raw = File.read!("./source/11.txt")
IO.inspect(Eleven.one(raw))
IO.inspect(Eleven.two(raw))
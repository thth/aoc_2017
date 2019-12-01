defmodule Three do
  def one(input) do
    min_distance = find_ring(input) - 1
    round(min_distance + additional_distance(find_ring(input), input))
  end

  defp find_ring(input, x \\ 1) do
    if odd_square(x) >= input do
      x
    else
      find_ring(input, x + 1)
    end
  end

  # defp find_larger_odd_square(input, x \\ 1) do
  #   if odd_square(x) >= input do
  #     {x, odd_square(x)}
  #   else
  #     find_larger_odd_square(input, x + 1)
  #   end
  # end

  defp additional_distance(n, input) do
    lowest_distance_in_ring(n)
    |> Enum.map(&(abs(&1 - input)))
    |> Enum.min()
  end

  defp lowest_distance_in_ring(1), do: [1,1,1,1]
  defp lowest_distance_in_ring(n) do
    max = :math.pow(((n * 2) - 1), 2)
    i = n - 1
    [max - (i * 7), max - (i * 5), max - (i * 3), max - i]
  end

  defp odd_square(n), do: :math.pow((n * 2) - 1, 2) 
  # defp odd_square_stream, do: Stream.unfold({3,1}, fn {x,a} -> {a, {x + 2, :math.pow(x, 2)}} end)

  # hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
  # hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh

  @base %{
          :latest => %{x: 0, y: 0},
          %{x: 0, y: 0} => %{from: :origin, value: 1}
        }

  def two(input, map \\ @base) do
    point = {_,m} = next_point(map) # this feels wrong
    if m[:value] > input do
      m[:value]
    else
      two(input, next_map(map, point))
    end
  end

  defp next_map(map, {key, value}) do
    # IO.inspect({key, value})
    %{map | latest: key} |> Map.put(key, value)
  end

  defp next_point(map) do
    l = map.latest
    # adj = get_adj(map)
    cond do
      map[l][:from] == :origin ->
        {%{x: l.x + 1, y: l.y}, %{from: :left, value: get_adj(%{map | latest: %{x: l.x + 1, y: l.y}})}}
      map[l][:from] == :left && map[%{x: l.x, y: l.y + 1}] ->
        {%{x: l.x + 1, y: l.y}, %{from: :left, value: get_adj(%{map | latest: %{x: l.x + 1, y: l.y}})}}
      map[l][:from] == :left ->
        {%{x: l.x, y: l.y + 1}, %{from: :down, value: get_adj(%{map | latest: %{x: l.x, y: l.y + 1}})}}
      map[l][:from] == :down && map[%{x: l.x - 1, y: l.y}] ->
        {%{x: l.x, y: l.y + 1}, %{from: :down, value: get_adj(%{map | latest: %{x: l.x, y: l.y + 1}})}}
      map[l][:from] == :down ->
        {%{x: l.x - 1, y: l.y}, %{from: :right, value: get_adj(%{map | latest: %{x: l.x - 1, y: l.y}})}}
      map[l][:from] == :right && map[%{x: l.x, y: l.y - 1}] ->
        {%{x: l.x - 1, y: l.y}, %{from: :right, value: get_adj(%{map | latest: %{x: l.x - 1, y: l.y}})}}
      map[l][:from] == :right ->
        {%{x: l.x, y: l.y - 1}, %{from: :up, value: get_adj(%{map | latest: %{x: l.x, y: l.y - 1}})}}
      map[l][:from] == :up && map[%{x: l.x + 1, y: l.y}] ->
        {%{x: l.x, y: l.y - 1}, %{from: :up, value: get_adj(%{map | latest: %{x: l.x, y: l.y - 1}})}}
      map[l][:from] == :up ->
        {%{x: l.x + 1, y: l.y}, %{from: :left, value: get_adj(%{map | latest: %{x: l.x + 1, y: l.y}})}}
      true ->
        raise "?"
    end
    # case map[l] do
    #   {:origin, v} -> {%{x: l.x + 1, y: l.y}, %{from: :left, value: v + adj}}
    #   {:left, v} when map[%{x: l[:x], y: l[:y] + 1}] -> {%{x: l.x + 1, y: l.y}, %{from: :left, value: v + adj}}
    #   {:left, v} -> {%{x: l.x, y: l.y + 1}, %{from: :down, value: v + adj}}
    #   {:down, v} when map[%{x: l.x - 1, y: l.y}] -> {%{x: l.x, y: l.y + 1}, %{from: :down, value: v + adj}}
    #   {:down, v} -> {%{x: l.x - 1, y: l.y}, %{from: :right, value: v + adj}}
    #   {:right, v} when map[%{x: l.x, y: l.y - 1}] -> {%{x: l.x - 1, y: l.y}, %{from: :right, value: v + adj}}
    #   {:right, v} -> {%{x: l.x, y: l.y - 1}, %{from: :up, value: v + adj}}
    #   {:up, v} when map[%{x: l.x + 1, y: l.y}] -> {%{x: l.x, y: l.y - 1}, %{from: :up, value: v + adj}}
    #   {:up, v} -> {%{x: l.x + 1, y: l.y}, %{from: :right, value: v + adj}}
    #   _ -> raise "?"
    # end
  end

  defp get_adj(map) do
    l = map.latest
    ee = map[%{x: l.x + 1, y: l.y}][:value]
    ne = map[%{x: l.x + 1, y: l.y + 1}][:value]
    nn = map[%{x: l.x, y: l.y + 1}][:value]
    nw = map[%{x: l.x - 1, y: l.y + 1}][:value]
    ww = map[%{x: l.x - 1, y: l.y}][:value]
    sw = map[%{x: l.x - 1, y: l.y - 1}][:value]
    ss = map[%{x: l.x, y: l.y - 1}][:value]
    se = map[%{x: l.x + 1, y: l.y - 1}][:value]
    [ee, ne, nn, nw, ww, sw, ss, se] |> Enum.filter(&(!is_nil(&1))) |> Enum.sum()
  end

end

raw = File.read!("./source/03.txt")
input = String.to_integer(raw)

IO.inspect(Three.one(input))
IO.inspect(Three.two(input))
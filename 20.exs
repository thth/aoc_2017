defmodule Twenty do
  def one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.scan(~r/a=<(-?\d+),(-?\d+),(-?\d+)/, &1, capture: :all_but_first))
    |> Enum.map(&List.first/1)
    |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
    |> Enum.with_index()
    |> Enum.min_by(fn {[a0,a1,a2],_} -> abs(a0) + abs(a1) + abs(a2) end)
    |> elem(1)
  end

  def two(input) do
    p_list =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&Regex.scan(~r/(-?\d+)/, &1, capture: :all_but_first))
      |> Enum.map(&Enum.map(&1, fn x -> List.first(x) end))
      |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
      |> Enum.map(fn [p0,p1,p2,v0,v1,v2,a0,a1,a2] -> [p: {p0,p1,p2}, v: {v0,v1,v2}, a: {a0,a1,a2}] end)
      |> remove_collided()
    p_list_after = sim_times(p_list, 1000)
    |> IO.inspect
    Enum.count(p_list_after)
  end

  # def sim(p_list, steps,)
  def sim_times(p_list, 0), do: p_list
  def sim_times(p_list, times_left) do
    new_list = p_list |> sim() |> remove_collided()
    sim_times(new_list, times_left - 1)
  end

  def sim(p_list) do
    Enum.map(p_list, fn [p: {p0,p1,p2}, v: {v0,v1,v2}, a: {a0,a1,a2}] ->
      [p: {p0+v0+a0,p1+v1+a1,p2+v2+a2},
       v: {v0+a0,v1+a1,v2+a2},
       a: {a0,a1,a2}] end)
  end

  def remove_collided(p_list), do: do_remove_collided(p_list, p_list)
  def do_remove_collided(p_list, recurse_over, to_remove \\ [])
  def do_remove_collided(p_list, [], to_remove) do
    Enum.filter(p_list, fn el -> if Keyword.get(el, :p) in to_remove, do: false, else: true end)
  end
  def do_remove_collided(p_list, [p_kl|t], to_remove) do
    p = Keyword.get(p_kl, :p)
    if Enum.any?(t, fn kl -> Keyword.get(kl, :p) == p end) do
      do_remove_collided(p_list, t, to_remove ++ [p])
    else
      do_remove_collided(p_list, t, to_remove)
    end
  end

end

input = File.read!("./source/20.txt")
# Twenty.one(input)
Twenty.two(input)
|> IO.inspect


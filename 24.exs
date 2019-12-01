defmodule Twentyfour do
  def one(input) do
    list = input |> String.split("\n", trim: true) |> Enum.map(&Regex.scan(~r/\d+/,&1)) |> Enum.map(&List.flatten/1) |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
    find_stronk(list) |> List.flatten |> Enum.max_by(fn {_,s} -> s end) |> elem(1)
  end

  def two(input) do
    list = input |> String.split("\n", trim: true) |> Enum.map(&Regex.scan(~r/\d+/,&1)) |> Enum.map(&List.flatten/1) |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
    find_stronk(list) |> List.flatten |> Enum.max_by(fn {d,s} -> (d * 10000) + s end) |> elem(1)
  end

  def find_stronk(list, port \\ 0, path \\ [])
  def find_stronk(list, port, path) do
    compatible = list |> Enum.filter(fn l -> port in l end)
    if compatible == [] do
      depth = Enum.count(path)
      strength = path |> List.flatten |> Enum.sum
      {depth, strength}
    else
      Enum.map(compatible, fn l -> find_stronk(list -- [l],List.first(l -- [port]), path ++ [l]) end)
    end
  end
end

input = File.read!("./source/24.txt")
# Twentyfour.one(input)
Twentyfour.two(input)
|> IO.inspect
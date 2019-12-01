defmodule One do
  def one(input) do
    last = input |> to_string() |> String.slice(-1..-1) |> String.to_integer
    input
    |> to_string()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce({0,last}, &(if &1 == elem(&2,1), do: {elem(&2,0) + &1, &1}, else: {elem(&2,0), &1}))
    |> elem(0)
  end

  def two(input) do
    input
    |> to_string()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Enum.reduce(0, &(if match(input,elem(&1,1)), do: &2 + elem(&1,0), else: &2))
  end

  def match(input, index) do
    list = input |> to_string() |> String.split("", trim: true)
    length = Enum.count(list)
    index_b = if index >= div(length, 2), do: index - div(length, 2), else: index + div(length, 2)
    a = Enum.at(list, index)
    b = Enum.at(list, index_b)
    a == b
  end
end 

input = File.read!("./source/01.txt")
IO.inspect(One.one(input))
IO.inspect(One.two(input))
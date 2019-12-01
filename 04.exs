raw = File.read!("./source/04.txt")
input = raw |> String.split("\n", trim: true)

defmodule Four do

  def one(input) do
    input |> Enum.map(&String.split/1) |> Enum.filter(fn l -> l == Enum.uniq(l) end) |> Enum.count
  end

  def two(input) do
    input
    |> Enum.map(&String.split/1)
    |> Enum.map(&Enum.map(&1, fn m -> Enum.sort(String.graphemes(m)) end))
    |> Enum.filter(fn l -> l == Enum.uniq(l) end)
    |> Enum.count
  end
end


IO.inspect(Four.one(input))
IO.inspect(Four.two(input))
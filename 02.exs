raw = File.read!("./source/02.txt")
input = raw
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split(&1,"\t", trim: true))
        |> Enum.map(fn a -> Enum.map(a, &String.to_integer/1) end)
        # |> Enum.map(&Enum.map(&1,fn a -> String.to_integer(a) end))

defmodule Two do
  def one(input) do
    input
    |> Enum.map(fn l -> Enum.max(l) - Enum.min(l) end)
    |> Enum.sum()
  end

  def two(input) do
    input
    |> Enum.map(&(find(&1)))
    |> Enum.sum()
    |> round()
  end

  defp find([]), do: 0
  defp find([head | tail]) do
    Enum.find_value(tail, fn x -> if rem(max(x, head), min(x, head)) == 0, do: max(x, head) / min(x,head) end) || find(tail)
  end
end

IO.inspect(Two.one(input))
IO.inspect(Two.two(input))
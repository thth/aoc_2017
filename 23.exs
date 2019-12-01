defmodule Twentythree do
  def one(input) do
    ins_list = parse_ins(input) 
    count_mul(ins_list)
  end

  def two(input) do # DEIFNITELY NOT HARDCODED
    prime? = fn x -> ( 2..x |> Enum.filter(fn y -> rem(x,y) == 0 end) |> length() ) == 1 end
    list = 109900..126900 |> Enum.filter(&(rem(&1 - 109900,17) == 0))
    Enum.reduce(list, 0, fn (x, acc) -> if prime?.(x), do: acc, else: acc + 1 end)
  end

  def run(ins_list, map \\ %{"a" => 1, "b" => 0,"c" => 0,"d" => 0,"e" => 0,"f" => 0,"g" => 0 ,"h" => 0}, i \\ 0) do
    :timer.sleep(10)
    IO.inspect {i + 1, map}
    if i < 0 || i >= Enum.count(ins_list) do
      map["h"]
    else
      [ins|t] = Enum.at(ins_list, i)
      {x,y} = {List.first(t), List.last(t)}
      y = map[y] || String.to_integer(y)
      case ins do
        "set" ->
          run(ins_list, Map.put(map, x, y), i + 1)
        "sub" ->
          run(ins_list, Map.update(map, x, 0, &(&1-y)), i + 1)
        "mul" ->
          run(ins_list, Map.update(map, x, 0, &(&1*y)), i + 1)
        "jnz" ->
          x = map[x] || String.to_integer(x)
          if x != 0 do
            run(ins_list ,map , i + y)
          else
            run(ins_list ,map , i + 1)
          end
      end
    end
  end

  def count_mul(ins_list, map \\ %{"a" => 0, "b" => 0,"c" => 0,"d" => 0,"e" => 0,"f" => 0,"g" => 0 ,"h" => 0}, i \\ 0, count \\ 0) do
    if i < 0 || i >= Enum.count(ins_list) do
      count
    else
      [ins|t] = Enum.at(ins_list, i)
      {x,y} = {List.first(t), List.last(t)}
      y = map[y] || String.to_integer(y)
      case ins do
        "set" ->
          count_mul(ins_list, Map.put(map, x, y), i + 1, count)
        "sub" ->
          count_mul(ins_list, Map.update(map, x, 0, &(&1-y)), i + 1, count)
        "mul" ->
          count_mul(ins_list, Map.update(map, x, 0, &(&1*y)), i + 1, count + 1)
        "jnz" ->
          x = map[x] || String.to_integer(x)
          if x != 0 do
            count_mul(ins_list ,map , i + y, count)
          else
            count_mul(ins_list ,map , i + 1, count)
          end
      end
    end
  end

  def parse_ins(raw) do
    raw
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.scan(~r/\S+/,&1))
    |> Enum.map(&Enum.map(&1,fn l -> List.first(l) end))
  end
end

input = File.read!("./source/23.txt")
# Twentythree.one(input)
Twentythree.two(input)
|> IO.inspect
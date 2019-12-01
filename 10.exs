defmodule Ten do
  use Bitwise
  @salt [17, 31, 73, 47, 23]

  def one(raw) do
    lengths = raw |> String.split(~r/,|\n/, trim: true) |> Enum.map(&String.to_integer/1)
    list = Enum.to_list(0..255)
    do_one(list,lengths,0,0)
  end

  def two(raw) do
    lengths = raw
                |> String.trim() # |> String.length()
                |> :binary.bin_to_list() # |> Enum.count()
                |> Kernel.++(@salt) # |> Enum.count()
    list = Enum.to_list(0..255)
    [shifted_sparse_hash,start_v,_] = Enum.reduce(0..63, [list, 0, 0], fn(_,acc) -> run_lengths(lengths, acc) end)
    sparse_hash = unshift(shifted_sparse_hash, start_v)
    dense_hash = sparse_hash |> Enum.chunk_every(16) |> Enum.map(&Enum.reduce(&1, fn (x, acc) -> x ^^^ acc end))
    dense_hash
    |> Enum.map(&:erlang.integer_to_list(&1,16))
    |> Enum.map(&List.to_string(&1))
    |> Enum.map(&String.pad_leading(&1,2,"0"))
    |> List.to_string()
    |> String.downcase
  end

  def do_one(list,[],start_v,_) do
    if Enum.find_index(list, &(&1 == start_v)) == (Enum.count(list) - 1) do
      start_v * Enum.at(list,0)
    else
      start_v * Enum.at(list,Enum.find_index(list, &(&1 == start_v)) + 1)
    end
  end
  def do_one(list,[len|t],start_v,skip) do
    start_i = Enum.find_index(list, &(&1 == start_v))
    {a,b} = Enum.split(list,len)
    list = Enum.reverse(a) ++ b
    new_v = Enum.at(list, start_i)
    new_i = rem(len + skip, Enum.count(list))
    {x,y} = Enum.split(list,new_i)
    list = y ++ x
    do_one(list,t,new_v,skip + 1)
  end

  def run_lengths([],[list,start_v,skip]), do: [list, start_v, skip]
  def run_lengths([len|t],[list,start_v,skip]) do
    start_i = Enum.find_index(list, &(&1 == start_v))
    {a,b} = Enum.split(list,len)
    list = Enum.reverse(a) ++ b
    new_v = Enum.at(list, start_i)
    new_i = rem(len + skip, Enum.count(list))
    {x,y} = Enum.split(list,new_i)
    list = y ++ x
    run_lengths(t,[list,new_v,skip + 1])
  end

  def unshift(list,v) do
    i = Enum.find_index(list, &(&1 == v))
    {a,b} = Enum.split(list,i)
    b ++ a
  end
end

# raw = File.read!("./source/10.txt")
# IO.inspect(Ten.two(raw))

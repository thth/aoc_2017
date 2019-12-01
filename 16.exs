defmodule Sixteen do
  @start ~w/a b c d e f g h i j k l m n o p/
  # @second ~w/e b j p f d g m i h o n a c k l/
  @prog_count 16
  # @start ~w/a b c d e/
  # @prog_count 5

  def one(raw) do
    ins_list = raw |> String.trim() |> String.split(",", trim: true) |> Enum.map(&parse_ins/1)
    run(@start,ins_list,1) |> Enum.join()
  end

  def two(raw) do
    ins_list = raw |> String.trim() |> String.split(",", trim: true) |> Enum.map(&parse_ins/1)
    runs_left = rem(1_000_000_000,count_run_until_same(@start,ins_list))
    run(@start, ins_list, runs_left) |> Enum.join()
  end

  def count_run_until_same(p_list,ins_list,count \\ 0) do
    new_list = run(p_list,ins_list,1)
    if new_list == @start do
      count + 1
    else
      count_run_until_same(new_list,ins_list,count + 1)
    end
  end

  def run(p_list,ins_list,times,count \\ 0) do
    # if rem(times-count,1_000_000) == 0, do: IO.inspect(count)
    if count == times do
      p_list
    else
      new_list = Enum.reduce(ins_list,p_list, fn(x,acc) -> do_ins(acc,x) end)
      run(new_list,ins_list,times,count + 1)
    end
  end

  def do_ins(p_list,{f,x}) do
    case f do
      :s ->
        {a,b} = Enum.split(p_list, @prog_count - x)
        b ++ a
      :x ->
        a = Enum.at(p_list,elem(x,0))
        b = Enum.at(p_list,elem(x,1))
        p_list |> List.replace_at(elem(x,0),b) |> List.replace_at(elem(x,1),a)
      :p ->
        a_i = p_list |> Enum.find_index(&(&1==elem(x,0)))
        b_i = p_list |> Enum.find_index(&(&1==elem(x,1)))
        p_list |> List.replace_at(a_i,elem(x,1)) |> List.replace_at(b_i,elem(x,0))
    end
  end

  def parse_ins(ins) do
    f = String.first(ins) |> String.to_atom()
    case f do
      :s ->
        n = List.first(Regex.run(~r/\d+/,ins)) |> String.to_integer()
        {f, n}
      :x ->
        [[a_i],[b_i]] = Regex.scan(~r/\d+/,ins)
        {f,{String.to_integer(a_i), String.to_integer(b_i)}}
      :p ->
        [[a],[b]] = Regex.scan(~r/(?!^)\w/,ins)
        {f,{a,b}}
    end
  end

end

raw = File.read!("./source/16.txt")
# raw = "s1,x3/4,pe/b"
IO.inspect Sixteen.one(raw)
IO.inspect(Sixteen.two(raw))
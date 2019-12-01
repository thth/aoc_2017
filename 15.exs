defmodule Fifteen do
  @a_multi 16807
  @b_multi 48271
  @divisor 2147483647

  def one(raw) do
    [a_seed,b_seed] = Regex.scan(~r/\d+/, raw) |> Enum.map(fn([x]) -> String.to_integer(x) end)
    judge1(a_seed,b_seed,40_000_000)
  end

  def two(raw) do
    [a_seed,b_seed] = Regex.scan(~r/\d+/, raw) |> Enum.map(fn([x]) -> String.to_integer(x) end)
    judge2(a_seed,b_seed,5_000_000)
  end

  def a_gen(n), do: rem(n * @a_multi, @divisor)
  def b_gen(n), do: rem(n * @b_multi, @divisor)

  def judge1(a,b,steps,count \\ 0)
  def judge1(_,_,0,count), do: count
  def judge1(a,b,steps,count) do
    # if rem(steps,10000) == 0, do: IO.inspect(steps)
    a_n = a_gen(a)
    b_n = b_gen(b)
    if j_match?(a_n,b_n), do: judge1(a_n,b_n,steps-1,count+1), else: judge1(a_n,b_n,steps-1,count)
  end

  def bin_16(x), do: x |> Integer.to_string(2) |> String.pad_leading(16,"0") |> String.slice(-16,16)
  def j_match?(a,b), do: bin_16(a) == bin_16(b)

  def judge2(a,b,steps,count \\ 0)
  def judge2(_,_,0,count), do: count
  def judge2(a,b,steps,count) do
    if rem(steps,10000) == 0, do: IO.inspect(steps)
    a_n = gen_until(a,&a_gen/1,4)
    b_n = gen_until(b,&b_gen/1,8)
    if j_match?(a_n,b_n), do: judge2(a_n,b_n,steps-1,count+1), else: judge2(a_n,b_n,steps-1,count)
  end

  def gen_until(x,f,d) do
    x_n = f.(x)
    if rem(x_n,d) == 0 do
      x_n
    else
      gen_until(x_n,f,d)
    end
  end
end

raw = File.read!("./source/15.txt")
# raw = "65 8921"
# IO.inspect(Fifteen.one(raw))
IO.inspect(Fifteen.two(raw))

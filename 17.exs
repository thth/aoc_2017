defmodule Seventeen do
  def one(raw) do
    steps = String.to_integer(raw)
    {buffer,pos} = spin(steps,2017)
    Enum.at(Stream.cycle(buffer), pos + 1)
  end

  def two(raw) do
    steps = String.to_integer(raw)
    cycle(steps, 50_000_000)
  end

  def spin(steps, stop, buffer \\ [0], pos \\ 0, count \\ 0)
  def spin(steps,stop,buffer,pos,count) do
    # if rem(count,1_000) == 0, do: IO.inspect(count)
    if count == stop do
      {buffer,pos}
    else
      new_pos = if (x = rem(steps + pos, count + 1) + 1) > count + 1, do: 0, else: x
      # new_pos = rem(steps + pos, count + 1) + 1
      # Enum.count(buffer) == count + 1
      new_buffer = List.insert_at(buffer,new_pos,count+1)
      spin(steps,stop,new_buffer,new_pos,count+1)
    end
  end

  def cycle(steps, stop, n \\ 0, match \\ 0, count \\ 0)
  def cycle(steps, stop, n, match, count) do
    if rem(count, 10_000) == 0, do: IO.inspect(count)
    if count == stop do
      match
    else
      # i = rem(steps + n, count + 1) + 1
      i = if (x = rem(steps + n, count + 1) + 1) > count + 1, do: 0, else: x
      # IO.inspect([n: n, count: count, i: i])
      if i == 1 do
        cycle(steps, stop, i, count + 1, count + 1)
      else
        cycle(steps, stop, i, match, count + 1)
      end
    end
  end
end
raw = File.read!("./source/17.txt")
# IO.inspect(Seventeen.one(raw))
IO.inspect(Seventeen.two(raw))
defmodule Nine do
  def one(raw) do
    {brackets,_} = degarb(<<>>,raw,0)
    max_depth = find_max_depth(brackets, 0, 0)
    find_score(<<>>, brackets, max_depth, 0, 0)
  end

  def two(raw) do
    {_,count} = degarb(<<>>,raw,0)
    count
  end

  def degarb(clean,<<>>,count), do: {clean,count}
  def degarb(clean,<<?<,?!,_,rest::binary>>,count), do: degarb(clean, <<?<,rest::binary>>, count)
  def degarb(clean,<<?<,?>,rest::binary>>,count), do: degarb(clean, rest, count)
  def degarb(clean,<<?<,_,rest::binary>>,count), do: degarb(clean, <<?<,rest::binary>>, count + 1)
  def degarb(clean,<<?{,rest::binary>>,count), do: degarb(clean <> "{", rest, count)
  def degarb(clean,<<?},rest::binary>>,count), do: degarb(clean <> "}", rest, count)
  def degarb(clean,<<_,rest::binary>>,count), do: degarb(clean, rest, count)

  def find_max_depth(<<>>,max,_), do: max
  def find_max_depth(<<?{,rest::binary>>, max, cur) do
    if cur + 1 > max do
      find_max_depth(rest, cur + 1, cur + 1)
    else
      find_max_depth(rest, max, cur + 1)
    end
  end
  def find_max_depth(<<?},rest::binary>>, max, cur), do: find_max_depth(<<rest::binary>>, max, cur-1)

  def find_score(<<>>,<<>>,_,_,score), do: score
  def find_score(a, <<?},b::binary>>, scored_depth, current_depth, score) do
    if scored_depth == current_depth do
      new_a = String.slice(a,0..-2)
      find_score(new_a, b, scored_depth, current_depth - 1, score + current_depth)
    else
      find_score(a <> "}", <<b::binary>>, scored_depth, current_depth - 1, score)
    end
  end
  def find_score(a, <<?{,b::binary>>, scored_depth, current_depth, score) do
    find_score(a <> "{", b, scored_depth, current_depth + 1, score)
  end
  def find_score(a, <<>>, scored_depth, _, score) do
    find_score(<<>>, a, scored_depth - 1, 0, score)
  end
end

raw = File.read!("./source/09.txt")
IO.inspect(Nine.one(raw))
IO.inspect(Nine.two(raw))
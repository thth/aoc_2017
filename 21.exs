defmodule Twentyone do
  @seed ".#./..#/###"

  def one(input) do
    rules = map_rules(input)
    gen(rules,5,@seed) |> String.graphemes |> Enum.filter(&(&1=="#")) |> Enum.count()
  end

  def two(input) do
    rules = map_rules(input)
    gen(rules,18,@seed) |> String.graphemes |> Enum.filter(&(&1=="#")) |> Enum.count()
  end

  def map_rules(input) do
    input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " => "))
      |> Enum.map(&List.to_tuple/1)
      |> Map.new()
  end

  def gen(rules,times,art \\ @seed)
  def gen(_, 0, art), do: art
  def gen(rules,times,art) do
    art_lines = art |> String.split("/")
    size = art_lines |> Enum.count
    art_chunks = if rem(size, 2) == 0, do: Enum.chunk_every(art_lines, 2), else: Enum.chunk_every(art_lines, 3)
    new_art =
      Enum.map(art_chunks, &process_chunks(rules,&1))
      |> Enum.map(&Enum.join(&1,"/"))
      |> Enum.join("/")
    gen(rules, times-1, new_art)
  end

  def process_chunks(r,l), do: if Enum.count(l) == 3, do: process_chunks3(r,l), else: process_chunks2(r,l)

  def process_chunks3(rules, input_list, output_list_of_lines \\ ["","","",""])
  def process_chunks3(_, ["","",""], output_list_of_lines), do: output_list_of_lines
  def process_chunks3(rules, [a,b,c], [l1,l2,l3,l4]) do
    <<s1,s2,s3,ar::binary>> = a
    <<s4,s5,s6,br::binary>> = b
    <<s7,s8,s9,cr::binary>> = c
    pattern = <<s1,s2,s3,?/,s4,s5,s6,?/,s7,s8,s9>>
    match = gen_next(pattern,rules)
    [o1,o2,o3,o4] = String.split(match, "/")
    process_chunks3(rules,[ar,br,cr],[l1<>o1,l2<>o2,l3<>o3,l4<>o4])
  end

  def process_chunks2(rules, input_list, output_list_of_lines \\ ["","",""])
  def process_chunks2(_, ["",""], output_list_of_lines), do: output_list_of_lines
  def process_chunks2(rules, [a,b], [l1,l2,l3]) do
    <<s1,s2,ar::binary>> = a
    <<s3,s4,br::binary>> = b
    pattern = <<s1,s2,?/,s3,s4>>
    match = gen_next(pattern,rules)
    [o1,o2,o3] = String.split(match, "/")
    process_chunks2(rules,[ar,br],[l1<>o1,l2<>o2,l3<>o3])
  end

  def gen_next(str,rules) do
    if String.length(str) == 5 do
      count_hash = &(&1 |> String.graphemes |> Enum.filter(fn c -> c == "#" end) |> Enum.count)
      case count_hash.(str) do
        0 -> rules["../.."]
        1 -> rules["#./.."]
        2 -> if str in ~w[.#/#. #./.#], do: rules[".#/#."], else: rules["##/.."]
        3 -> rules["##/#."]
        4 -> rules["##/##"]
      end
    else
      d = fn <<x1,x2,x3,?/,x4,x5,x6,?/,x7,x8,x9>> -> <<x1,x4,x7,?/,x2,x5,x8,?/,x3,x6,x9>> end
      r = fn <<x1,x2,x3,?/,x4,x5,x6,?/,x7,x8,x9>> -> <<x7,x4,x1,?/,x8,x5,x2,?/,x9,x6,x3>> end
      cond do
        str in Map.keys(rules) -> rules[str]
        d.(str) in Map.keys(rules) -> rules[d.(str)]
        r.(str) in Map.keys(rules) -> rules[r.(str)]
        d.(r.(str)) in Map.keys(rules) -> rules[d.(r.(str))]
        r.(r.(str)) in Map.keys(rules) -> rules[r.(r.(str))]
        d.(r.(r.(str))) in Map.keys(rules) -> rules[d.(r.(r.(str)))]
        r.(r.(r.(str))) in Map.keys(rules) -> rules[r.(r.(r.(str)))]
        d.(r.(r.(r.(str)))) in Map.keys(rules) -> rules[d.(r.(r.(r.(str))))]
        true -> raise str
      end
    end
  end
end

input = File.read!("./source/21.txt")
# Twentyone.one(input)
Twentyone.two(input)
|> IO.inspect
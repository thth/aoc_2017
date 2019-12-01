defmodule Eighteen do
  def one(raw) do
    ins_list = parse_ins(raw)
    run_until_rcv(ins_list)
  end

  def two(raw) do
    ins_list = parse_ins(raw)
    run_duet(ins_list)
  end

  def run_duet(ins_list, m0 \\ %{"p" => 0}, i0 \\ 0, q0 \\ [], w0 \\ false, m1 \\ %{"p" => 1}, i1 \\ 0, q1 \\ [], w1 \\ false, c1 \\ 0) do
    # IO.inspect([i0: i0, w0: w0, q0: List.first(q0), i1: i1, w1: w1, q1: List.first(q1), c1: c1])
    cond do
      w0 == false && i0 >= 0 && i0 < Enum.count(ins_list) ->
        [ins|t] = Enum.at(ins_list, i0)
        {x,y} = {List.first(t), List.last(t)}
        y =
          if y in ~w/a b c d e f g h i j k l m n o p q r s t u v w x y z/ do
            Map.get(m0, y, 0)
          else
            String.to_integer(y)
          end
        # y = m0[y] || String.to_integer(y)
        case ins do
          "snd" ->
            run_duet(ins_list, m0, i0 + 1, q0, w0, m1, i1, q1 ++ [y], false, c1)
          "set" ->
            new_m0 = Map.put(m0, x, y)
            run_duet(ins_list, new_m0, i0 + 1, q0, w0, m1, i1, q1, w1, c1)
          "add" ->
            new_m0 = Map.update(m0, x, 0, &(&1+y))
            run_duet(ins_list, new_m0, i0 + 1, q0, w0, m1, i1, q1, w1, c1)
          "mul" ->
            new_m0 = Map.update(m0, x, 0, &(&1*y))
            run_duet(ins_list, new_m0, i0 + 1, q0, w0, m1, i1, q1, w1, c1)
          "mod" ->
            new_m0 = Map.update(m0, x, 0, &(rem(&1,y)))
            run_duet(ins_list, new_m0, i0 + 1, q0, w0, m1, i1, q1, w1, c1)
          "rcv" ->
            if q0 == [] do
              run_duet(ins_list, m0, i0, q0, true, m1, i1, q1, w1, c1)
            else
              [q|t] = q0
              new_m0 = Map.put(m0, x, q)
              run_duet(ins_list, new_m0, i0 + 1, t, w0, m1, i1, q1, w1, c1)
            end
          "jgz" ->
            x = m0[x] || String.to_integer(x)
            if x > 0 do
              run_duet(ins_list, m0, i0 + y, q0, w0, m1, i1, q1, w1, c1)
            else
              run_duet(ins_list, m0, i0 + 1, q0, w0, m1, i1, q1, w1, c1)
            end
        end
      w1 == false && i1 >= 0 && i1 < Enum.count(ins_list) ->
        [ins|t] = Enum.at(ins_list, i1)
        {x,y} = {List.first(t), List.last(t)}
        y =
          if y in ~w/a b c d e f g h i j k l m n o p q r s t u v w x y z/ do
            Map.get(m1, y, 0)
          else
            String.to_integer(y)
          end
        # y = m1[y] || String.to_integer(y)
        case ins do
          "snd" ->
            run_duet(ins_list, m0, i0, q0 ++ [y], false, m1, i1 + 1, q1 , w1, c1 + 1)
          "set" ->
            new_m1 = Map.put(m1, x, y)
            run_duet(ins_list, m0, i0, q0, w0, new_m1, i1 + 1, q1, w1, c1)
          "add" ->
            new_m1 = Map.update(m1, x, 0, &(&1+y))
            run_duet(ins_list, m0, i0, q0, w0, new_m1, i1 + 1, q1, w1, c1)
          "mul" ->
            new_m1 = Map.update(m1, x, 0, &(&1*y))
            run_duet(ins_list, m0, i0, q0, w0, new_m1, i1 + 1, q1, w1, c1)
          "mod" ->
            new_m1 = Map.update(m1, x, 0, &(rem(&1,y)))
            run_duet(ins_list, m0, i0, q0, w0, new_m1, i1 + 1, q1, w1, c1)
          "rcv" ->
            if q1 == [] do
              run_duet(ins_list, m0, i0, q0, w0, m1, i1, q1, true, c1)
            else
              [q|t] = q1
              new_m1 = Map.put(m1, x, q)
              run_duet(ins_list, m0, i0, q0, w0, new_m1, i1 + 1, t, w1, c1)
            end
          "jgz" ->
            x = m1[x] || String.to_integer(x)
            if x > 0 do
              run_duet(ins_list, m0, i0, q0, w0, m1, i1 + y, q1, w1, c1)
            else
              run_duet(ins_list, m0, i0, q0, w0, m1, i1 + 1, q1, w1, c1)
            end
        end
      true ->
        c1
    end
  end


  def run_until_rcv(ins_list, map \\ %{}, i \\ 0, snd \\ []) do
    [ins|t] = Enum.at(ins_list, i)
    {x,y} = {List.first(t), List.last(t)}
    y = map[y] || String.to_integer(y)
    case ins do
      "snd" ->
        run_until_rcv(ins_list, map, i + 1, snd ++ [y])
      "set" ->
        run_until_rcv(ins_list, Map.put(map, x, y), i + 1, snd)
      "add" ->
        run_until_rcv(ins_list, Map.update(map, x, 0, &(&1+y)), i + 1, snd)
      "mul" ->
        run_until_rcv(ins_list, Map.update(map, x, 0, &(&1*y)), i + 1, snd)
      "mod" ->
        run_until_rcv(ins_list, Map.update(map, x, 0, &(rem(&1,y))), i + 1, snd)
      "rcv" ->
        if y == 0 do
          run_until_rcv(ins_list, map, i + 1, snd)
        else
          List.last(snd)
        end
      "jgz" ->
        x = map[x] || String.to_integer(x)
        if x > 0 do
          run_until_rcv(ins_list, map, i + y, snd)
        else
          run_until_rcv(ins_list, map, i + 1, snd)
        end
      _ ->
        raise ins
    end
  end

  def parse_ins(raw) do
    raw
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.scan(~r/\S+/,&1))
    |> Enum.map(&Enum.map(&1,fn l -> List.first(l) end))
  end

end

raw = File.read!("./source/18.txt")
# Eighteen.one(raw)
Eighteen.two(raw)
|> IO.inspect
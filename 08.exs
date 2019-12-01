defmodule Eight do
  def one(raw) do
    list = raw |> String.split("\n", trim: true)
    map = populate_map(%{}, list)
    {_, largest_value} = Enum.max_by(map, &(elem(&1,1)))
    largest_value
  end

  def two(raw) do
    list = raw |> String.split("\n", trim: true)
    return_max(%{}, list, 0)
  end

  def populate_map(map, []), do: map
  def populate_map(map, [line|rest]) do
    r = ~r/^(\w+)\s(\w+)\s(\S+)\sif\s(\w+)\s(\S+)\s(\S+)$/
    [
      reg1,
      change_direction,
      change_value,
      reg2,
      cond_comparison,
      cond_value
    ] = Regex.run(r, line, capture: :all_but_first)
    map = if !Map.has_key?(map, reg1), do: Map.put(map, reg1, 0), else: map
    map = if !Map.has_key?(map, reg2), do: Map.put(map, reg2, 0), else: map
    map = if condition_met?(map[reg2], cond_comparison, cond_value) do
            apply_change(map, reg1, change_direction, change_value)
          else
            map
          end
    populate_map(map, rest)
  end

  def return_max(map, [], max), do: max
  def return_max(map, [line|rest], max) do
    r = ~r/^(\w+)\s(\w+)\s(\S+)\sif\s(\w+)\s(\S+)\s(\S+)$/
    [
      reg1,
      change_direction,
      change_value,
      reg2,
      cond_comparison,
      cond_value
    ] = Regex.run(r, line, capture: :all_but_first)
    map = if !Map.has_key?(map, reg1), do: Map.put(map, reg1, 0), else: map
    map = if !Map.has_key?(map, reg2), do: Map.put(map, reg2, 0), else: map
    map = if condition_met?(map[reg2], cond_comparison, cond_value) do
            apply_change(map, reg1, change_direction, change_value)
          else
            map
          end
    applied = map[reg1]
    max = if applied > max, do: applied, else: max
    return_max(map, rest, max)
  end

  def condition_met?(a, comparison, b) do
    a = if is_integer(a), do: a, else: String.to_integer(a)
    b = if is_integer(b), do: b, else: String.to_integer(b)
    case comparison do
      ">" -> a > b
      ">=" -> a >= b
      "<" -> a < b
      "<=" -> a <= b
      "==" -> a == b
      "!=" -> a != b
      _ -> raise "?"
    end
  end

  def apply_change(map, key, direction, value) do
    value = String.to_integer(value)
    current_value = map[key]
    if direction == "inc" do
      %{map | key => current_value + value}
    else
      %{map | key => current_value - value}
    end
  end
end

raw = File.read!("./source/08.txt")
IO.inspect(Eight.one(raw))
IO.inspect(Eight.two(raw))
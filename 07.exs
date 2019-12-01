defmodule Seven do
  @regex ~r/^(?<node>\w+)\s\((?<weight>\d+)\)(?:\s\W+(?<children>.+))?$/
  @root "ahnofa" # obtained through magical Seven.one(raw)

  def process_raw(raw) do
    raw
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.named_captures(@regex,&1))
    |> Map.new(&transform_f/1)
  end

  defp transform_f(e) do
    if e["children"] == "" do
      {
        e["node"],
        %{weight: String.to_integer(e["weight"])}
      }
    else
      {
        e["node"],
        %{
          weight: String.to_integer(e["weight"]),
          children: String.split(e["children"], ", ")
        }
      }
    end
  end

  def two(raw) do
    map = process_raw(raw)
    fatty = find_fatty(map, @root)
    children_weight = Enum.reduce(get_weight_of_children(map, fatty), 0, fn (x, acc) -> elem(x,1) + acc end)
    {:ok, fatty_regex} = Regex.compile("^.+#{fatty}")
    parent_of_fatty_line = raw |> String.split("\n", trim: true) |> Enum.find(&Regex.match?(fatty_regex,&1))
    [parent_of_fatty | _] = Regex.run(~r/^(\w+)/, parent_of_fatty_line)
    weight_of_children = get_weight_of_children(map, parent_of_fatty)
    [{_, weight_of_first} | _] = weight_of_children
    # first child is fat
    weight_difference =
      if weight_of_first != elem(Enum.at(weight_of_children, 1),1) && weight_of_first != elem(Enum.at(weight_of_children, 2),1) do
        weight_of_first - elem(Enum.at(weight_of_children, 1), 1)
      else
        {_, problem_child_weight} = Enum.find(weight_of_children, &(weight_of_first != elem(&1,1)))
        abs(weight_of_first - problem_child_weight)
      end
    map[fatty].weight - weight_difference
  end

  def find_fatty(map, parent) do
    if !Map.has_key?(map[parent], :children) do
      parent
    else
      weight_of_children = get_weight_of_children(map, parent) # Enum.map(map[parent].children, fn c -> {c, get_weight_of_prog(map, c)} end)
      [{_, weight_of_first} | _] = weight_of_children
      cond do
        Enum.all?(weight_of_children, &(elem(&1, 1) == weight_of_first)) ->
          parent
        Enum.count(weight_of_children) > 2 ->
          # first child is fat
          if weight_of_first != elem(Enum.at(weight_of_children, 1),1) && weight_of_first != elem(Enum.at(weight_of_children, 2),1) do
            find_fatty(map, Enum.at(weight_of_children, 0))
          else
            {problem_child, _} = Enum.find(weight_of_children, &(weight_of_first != elem(&1,1)))
            find_fatty(map, problem_child)
          end
        true -> raise "?"
      end
    end
  end

  def get_weight_of_children(map, parent) do
    Enum.map(map[parent].children, fn c -> {c, get_weight_of_prog(map, c)} end)
  end

  def get_weight_of_prog(map, prog) do
    self = map[prog]
    self_weight = self.weight
    if Map.has_key?(self, :children) do
      children_weight = Enum.reduce(self.children, 0, fn(x, acc) -> get_weight_of_prog(map, x) + acc end)
      self_weight + children_weight
    else
      self_weight
    end
  end
end

raw = File.read!("./source/07.txt")
IO.inspect(Seven.two(raw))
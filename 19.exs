defmodule Nineteen do
  def one(raw) do
    maze = raw |> String.split("\n", trim: true) |> Enum.map(&String.split(&1,""))
    {letters,_} = navigate_maze(maze)
    letters |> List.to_string()
  end

  def two(raw) do
    maze = raw |> String.split("\n", trim: true) |> Enum.map(&String.split(&1,""))
    {_,steps} = navigate_maze(maze)
    steps
  end

  def navigate_maze(maze, pos \\ nil, dir \\ nil, letters \\ [], steps \\ 0)
  def navigate_maze(maze, nil, _, _, _) do
    x = maze |> List.first() |> Enum.find_index(&(&1 == "|"))
    navigate_maze(maze, {x,0}, :down, [], 0)
  end
  def navigate_maze(maze,{x,y},dir,letters, steps) do
    {n_x,n_y,str} = find_next(maze, {x,y}, dir)
    if str == " " do
      {letters, steps + 1}
    else
      case str do
        s when s in ["|","-"] ->
          navigate_maze(maze,{n_x,n_y},dir,letters, steps + 1)
        "+" ->
          next_dir = find_next_dir(maze, {n_x,n_y}, dir)
          navigate_maze(maze,{n_x,n_y},next_dir,letters, steps + 1)
        ltr ->
          navigate_maze(maze,{n_x,n_y},dir,letters ++ [ltr], steps + 1)
      end
    end
  end

  def find_next(maze, {x,y}, dir) do
    case dir do
      :down ->
        {x, y + 1, maze |> Enum.at(y + 1) |> Enum.at(x)}
      :up ->
        {x, y - 1, maze |> Enum.at(y - 1) |> Enum.at(x)}
      :right ->
        {x + 1, y, maze |> Enum.at(y) |> Enum.at(x + 1)}
      :left ->
        {x - 1, y, maze |> Enum.at(y) |> Enum.at(x - 1)}
      _ ->
        raise "pos: {#{x},#{y}}, dir: #{dir}"
    end
  end

  def find_next_dir(maze, {x,y}, from_dir) do
    cond do
      from_dir != :up && maze |> Enum.at(y + 1) |> Enum.at(x) != " " -> :down
      from_dir != :down && maze |> Enum.at(y - 1) |> Enum.at(x) != " " -> :up
      from_dir != :left && maze |> Enum.at(y) |> Enum.at(x + 1) != " " -> :right
      from_dir != :right && maze |> Enum.at(y) |> Enum.at(x - 1) != " " -> :left
      true -> raise "pos: {#{x},#{y}}, from_dir: #{from_dir}"
    end
  end
end

raw = File.read!("./source/19.txt")
# Nineteen.one(raw)
Nineteen.two(raw)
|> IO.inspect
defmodule Twentytwo do
  def one(input) do
    grid = process_input(input)
    sim(grid,{12,12},:n,10_000)
  end

  def two(input) do
    grid = process_input2(input)
    sim2(grid,{12,12},:n,10_000_000)
  end

  def sim(grid,pos,dir,times,count \\ 0)
  def sim(_,_,_,0,count), do: count
  def sim(grid,{x,y},dir,times,count) do
    inf? = MapSet.member?(grid, {x,y})
    new_dir = if inf?, do: change_dir(dir,true), else: change_dir(dir,false)
    new_grid = if inf?, do: MapSet.delete(grid, {x,y}), else: MapSet.put(grid, {x,y})
    new_count = if inf?, do: count, else: count + 1
    case new_dir do
      :n -> sim(new_grid,{x,y-1},new_dir,times - 1, new_count)
      :s -> sim(new_grid,{x,y+1},new_dir,times - 1, new_count)
      :e -> sim(new_grid,{x+1,y},new_dir,times - 1, new_count)
      :w -> sim(new_grid,{x-1,y},new_dir,times - 1, new_count)
    end
  end

  def sim2(grid,pos,dir,times,count \\ 0)
  def sim2(_,_,_,0,count), do: count
  def sim2(grid,{x,y},dir,times,count) do
    state = Map.get(grid, {x,y})
    new_dir = change_dir2(dir,state)
    new_grid =
      case state do
        nil -> Map.put(grid,{x,y},:w)
        :w -> Map.put(grid,{x,y},:i)
        :i -> Map.put(grid,{x,y},:f)
        :f -> Map.put(grid,{x,y},nil)
      end
    new_count = if state == :w, do: count + 1, else: count
    case new_dir do
      :n -> sim2(new_grid,{x,y-1},new_dir,times - 1, new_count)
      :s -> sim2(new_grid,{x,y+1},new_dir,times - 1, new_count)
      :e -> sim2(new_grid,{x+1,y},new_dir,times - 1, new_count)
      :w -> sim2(new_grid,{x-1,y},new_dir,times - 1, new_count)
    end
  end

  def change_dir2(dir, state) do
    case state do
      nil ->
        case dir do
          :n -> :w
          :w -> :s
          :s -> :e
          :e -> :n
        end
      :w -> dir
      :i ->
        case dir do
          :n -> :e
          :e -> :s
          :s -> :w
          :w -> :n
        end
      :f ->
        case dir do
          :n -> :s
          :s -> :n
          :e -> :w
          :w -> :e
        end
    end
  end

  def change_dir(dir, infected) do
   case dir do
     :n -> if infected, do: :e, else: :w
     :s -> if infected, do: :w, else: :e
     :e -> if infected, do: :s, else: :n
     :w -> if infected, do: :n, else: :s
   end  
  end

  def process_input(input, pos \\ {0,0}, output \\ MapSet.new())
  def process_input("",_,grid), do: grid
  def process_input(<<c,t::binary>>, {x,y}, grid) do
    case c do
      ?\n -> process_input(t,{0,y+1},grid)
      ?. -> process_input(t,{x+1,y},grid)
      ?# -> process_input(t,{x+1,y},MapSet.put(grid,{x,y}))
      _ -> raise <<c>>
    end
  end

  def process_input2(input, pos \\ {0,0}, output \\ %{})
  def process_input2("",_,grid), do: grid
  def process_input2(<<c,t::binary>>, {x,y}, grid) do
    case c do
      ?\n -> process_input2(t,{0,y+1},grid)
      ?. -> process_input2(t,{x+1,y},grid)
      ?# -> process_input2(t,{x+1,y},Map.put(grid, {x,y}, :i))
      _ -> raise <<c>>
    end
  end
end

input = File.read!("./source/22.txt")
# Twentytwo.one(input)
Twentytwo.two(input)
|> IO.inspect
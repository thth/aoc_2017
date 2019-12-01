defmodule Fourteen do
  require Ten
  defmodule Square, do: defstruct  used: nil, region: nil

  def one(raw) do
    hexstring_list = for n <- 0..127, do: Ten.two(raw <> "-" <> Integer.to_string(n))
    binary_list = Enum.map(hexstring_list, &hexstring_to_binary_list(&1))
    binary_list |> Enum.map(&Enum.filter(&1,fn x -> x == "1" end)) |> Enum.map(&Enum.count(&1)) |> Enum.sum()
  end

  def two(raw) do
    hexstring_list = for n <- 0..127, do: Ten.two(raw <> "-" <> Integer.to_string(n))
    binary_list = Enum.map(hexstring_list, &hexstring_to_binary_list(&1))
    square_grid = binary_list_to_square_grid(binary_list)
    {_,count} = populate_regions(square_grid)
    ###
    # output to file
    # File.write!("./14_#{raw}_input.txt", struct_list_to_string(square_grid))
    # {populated_struct_list,count} = populate_regions(square_grid)
    # File.write!("./14_#{raw}_output.txt", struct_list_to_string(populated_struct_list))
    ###
    count
  end

  def struct_list_to_string(list) do
    help = fn(map) -> if map.region, do: Integer.to_string(map.region), else: (if !map.used, do: ".", else: "x") end
    region_grid = Enum.map(list, fn l -> Enum.map(l, help) end)
    region_grid |> Enum.map(&Enum.map(&1,fn s -> String.pad_trailing(s, 5, " ") end)) |> Enum.map(&List.to_string(&1) <> "\n")
  end

  def hexstring_to_binary_list(hexstring) do
    hexstring
    # |> String.graphemes()
    # |> Enum.map(&(String.to_integer(&1, 16)))
    # |> Enum.map(&(Integer.to_string(&1, 2)))
    # |> Enum.map(&(String.pad_leading(&1, 4, "0")))
    # |> Enum.join
    # |> String.graphemes()
    |> Integer.parse(16)
    |> elem(0)
    |> Integer.to_string(2)
    |> String.pad_leading(128, "0")
    |> String.split("", trim: true)
  end

  def binary_list_to_square_grid(binary_list) do
    transform = fn(s) -> if s == "1", do: %Square{used: true}, else: %Square{used: false} end
    Enum.map(binary_list, &Enum.map(&1,transform))
  end

  def populate_regions(square_grid, region_to_populate \\ 1, found_region \\ false, {x,y} \\ {0,0}) do
    depth = square_grid |> List.first |> Enum.count
    cond do
      y >= Enum.count(square_grid) && found_region == false ->
        {square_grid, region_to_populate - 1}
      y >= Enum.count(square_grid) && found_region == true ->
        IO.inspect(region_to_populate)
        populate_regions(square_grid, region_to_populate + 1)
      (square_grid |> Enum.at(y) |> Enum.at(x)).used && (square_grid |> Enum.at(y) |> Enum.at(x)).region == nil && found_region == false ->
        new_grid = List.replace_at(square_grid,y,List.replace_at(Enum.at(square_grid,y),x,%Square{used: true, region: region_to_populate}))
        populate_regions(new_grid, region_to_populate, true)
      (square_grid |> Enum.at(y) |> Enum.at(x)).used && (square_grid |> Enum.at(y) |> Enum.at(x)).region == nil && found_region == true && adjacent_region(square_grid,{x,y}) == region_to_populate ->
        new_grid = List.replace_at(square_grid,y,List.replace_at(Enum.at(square_grid,y),x,%Square{used: true, region: region_to_populate}))
        populate_regions(new_grid, region_to_populate, true)
      x + 1 < depth ->
        populate_regions(square_grid, region_to_populate, found_region, {x+1,y})
      x + 1 == depth ->
        populate_regions(square_grid, region_to_populate, found_region, {0,y+1})
      true ->
        raise "a"
    end
  end

  # def adjacent_regioned?(square_grid,{x,y}) do
  #   north = (s = Enum.at(square_grid,y-1) && Enum.at(Enum.at(square_grid,y-1),x)) && s.used && !!s.region
  #   south = (s = Enum.at(square_grid,y+1) && Enum.at(Enum.at(square_grid,y+1),x)) && s.used && !!s.region
  #   east = (s = Enum.at(Enum.at(square_grid,y),x + 1)) && s.used && !!s.region
  #   west = (s = Enum.at(Enum.at(square_grid,y),x - 1)) && s.used && !!s.region
  #   north || south || east || west
  # end

  def adjacent_region(square_grid,{x,y}) do
    north = if y == 0 do
      nil
    else
      (s = Enum.at(square_grid,y-1) && Enum.at(Enum.at(square_grid,y-1),x)) && s.used && s.region
    end
    south = (s = Enum.at(square_grid,y+1) && Enum.at(Enum.at(square_grid,y+1),x)) && s.used && s.region
    east = (s = Enum.at(Enum.at(square_grid,y),x + 1)) && s.used && s.region
    west = if x == 0 do
      nil
    else 
      (s = Enum.at(Enum.at(square_grid,y),x - 1)) && s.used && s.region
    end
    north || south || east || west
    # if output != nil do
    #   if ((north != output && north != nil) || (south != output && south != nil) || (east != output && east != nil) || (west != output && west != nil)) do
    #     IO.inspect([output: output, north: north, south: south, east: east, west: west])
    #     raise "b"
    #   end
    # end
    # output
  end
end
raw = File.read!("./source/14.txt")
# raw = "flqrgnkx"
# IO.inspect(Fourteen.one(raw))
IO.inspect(Fourteen.two(raw))
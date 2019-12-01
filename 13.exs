defmodule Thirteen do
  defmodule Layer do
    defstruct range: 0, scanner: 0, inc: true
  end

  def one(raw) do
    firewall = create_firewall(raw)
    sim(firewall)
  end

  def two(raw) do
    original_firewall = create_firewall(raw)
    sim_until_free(original_firewall)
  end

  def create_firewall(raw) do
    raw
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.scan(~r/\d+/,&1))
    |> Enum.map(fn([[a],[b]]) -> {String.to_integer(a), %Layer{range: String.to_integer(b)}} end)
    |> Enum.into(%{})
  end

  def sim(original_firewall, time \\ 0, pos \\ 0, severity \\ 0) do
    if pos > (original_firewall |> Map.keys |> Enum.max) do
      severity
    else
      firewall = firewall_at_time(original_firewall,time)
      new_severity = if firewall[pos] && firewall[pos].scanner == 0 do
                       severity + (pos * firewall[pos].range)
                     else
                      severity
                     end
      sim(original_firewall, time + 1, pos + 1, new_severity)
    end
  end

  def sim_until_free(firewall, time \\ 0, packet_time_elapsed \\ [0]) do
    if Enum.max(packet_time_elapsed) > (firewall |> Map.keys |> Enum.max) do
      time - Enum.max(packet_time_elapsed)
    else
      catches = firewall
                |> Enum.filter(fn {_,v} -> v.scanner == 0 end)
                |> Enum.map(fn {k,_} -> k end)
      packet_time_elapsed = packet_time_elapsed |> Kernel.--(catches) |> Enum.map(&(&1+1)) |> Kernel.++([0]) |> Enum.sort()
      sim_until_free(step_firewall(firewall), time + 1, packet_time_elapsed)
    end
  end

  def firewall_at_time(original_firewall,time) do
    if time == 0 do
      original_firewall
    else
      Enum.reduce(0..(time-1), original_firewall, fn(_,acc) -> step_firewall(acc) end)
    end
  end

  def step_firewall(firewall) do
    firewall |> Enum.map(fn {k,v} -> step_layer({k,v}) end) |> Enum.into(%{})
  end

  def step_layer({k,v}) do
    cond do
      v.inc && v.scanner + 2 < v.range ->
        {k,%Layer{v | scanner: v.scanner + 1, inc: true}}
      v.inc ->
        {k,%Layer{v | scanner: v.scanner + 1, inc: false}}
      !v.inc && v.scanner - 2 >= 0 ->
        {k,%Layer{v | scanner: v.scanner - 1, inc: false}}
      !v.inc ->
        {k,%Layer{v | scanner: v.scanner - 1, inc: true}}
    end
  end

  def try_until_escape(original_firewall, time \\ 0) do
    severity = sim(original_firewall,time)
    if severity != 0 || firewall_at_time(original_firewall,time)[0].scanner == 0 do
      try_until_escape(original_firewall, time + 1)
    else
      time
    end
  end
end

raw = File.read!("./source/13.txt")
# raw = "0: 3\n1: 2\n4: 4\n6: 4"
IO.inspect Thirteen.one(raw)
IO.inspect Thirteen.two(raw)
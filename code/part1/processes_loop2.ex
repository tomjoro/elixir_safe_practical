defmodule Loop2 do
  def init() do
    IO.puts "Loop2 starting"
    loop([])
  end

  def loop(a) do
    receive do
      string -> IO.puts string
    end
    a = [3 | a]
    value = loop(a)
    IO.puts value
  end
end

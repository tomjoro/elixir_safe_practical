defmodule Loop2 do
  def init() do
    IO.puts "Loop2 starting"
    loop()
  end

  def loop() do
    receive do
      string -> IO.puts string
    end
    loop()
  end
end


defmodule MakeLittle do

  width = 1000

  size = width * width

  File.open("big.raw", [:write, :binary], fn f ->
    Enum.each(1..size, fn i ->
      IO.binwrite(f, <<i::little-16>>)
    end)
  end)

end

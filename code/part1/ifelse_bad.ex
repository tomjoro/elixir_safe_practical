defmodule IfElse do
  def func1 do
    a = 3
    a = func2(a)
    IO.puts "#{a}"
  end

  def func2(b) do
    if true do
      b = 4
      c = 5
    end
    IO.puts "#{c}"
    b
  end
end


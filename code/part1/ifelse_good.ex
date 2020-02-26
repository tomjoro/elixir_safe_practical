
defmodule IfElse2 do
  def func1 do
    a = 3
    {b, c} = func2(a)
    IO.puts "#{a} #{b} #{c}"
  end

  def func2(m) do
    {m, n} = if true do
      b = 4
      c = 5
      {b, c}
    end
    {m, n}
  end
end

defmodule Loop do

  def start do
    IO.puts "Welcome to my loop program"
    loop(5)
  end

  def loop(0) do
    IO.puts("Sorry, try again next time.")
  end

  def loop(-1) do
    IO.puts("You got it!")
  end

  def loop(remaining) do
    input = IO.gets "Try: #{remaining} Please guess my age > "
    {i, junk} = Integer.parse(input)
    cond do
      i < 54 -> IO.puts "Guess higher"
      i > 54 -> IO.puts "Guess lower"
      true -> loop(-1)
    end
    loop(remaining-1)
  end
end

Loop.start


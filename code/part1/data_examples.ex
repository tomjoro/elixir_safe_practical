defmodule DataExamples do


  def basic do

    map = %{"map_with_strings" => 1, :mixed => 3}
    symbol = :this_is_symbol

    # this is a comment
    # Date.utc_today/1  just means it takes one parameter
    # h Date.utc_today will give you help

    list = [ 1, 2, 3]
    list = [ 0 | list]    # push on head of list
    IO.puts hd(list)

    list = Enum.reverse(list)
    IO.puts "#{inspect(list)}"

    _tuple = {1, 2, 3}   # this will be 1) unused warning, and return value
  end

  def advanced do
      # pattern matching
      map = %{"map_with_strings" => 1, :mixed => 3}

      %{"map_with_strings" => whats_value} = map
      IO.puts "whats_value = #{whats_value}"

      # anonymous functions
      list = [1, 2, 3, 4]
      even = Enum.filter(list, fn x -> rem(x, 2) == 0 end)
  end

  def pipe(first, other) do
    IO.puts first
    IO.puts other
    other
  end

  def demo_pipe do
    other = 99
    3 |> pipe(other) |> pipe(44)
  end


end

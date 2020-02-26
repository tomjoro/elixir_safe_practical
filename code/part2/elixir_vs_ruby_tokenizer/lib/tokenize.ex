defmodule Tokenize do

  def main(args) do
    str1 = "%{ [ ]  =>, , , , ,, ,, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }   "
    str2 = "%{ [ ]  =>, , , , ,, ,, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }   "
    str3 = "%{ [ ]  =>, , , , ,, ,, => , , , , , , , , , , , , , , [][][][][] , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }   "
    str4 = ~s"""
    %{ [ ]  =>, , , , ,, ,, => , , , , , , , , , , , , , , [][][][][] , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }
    %{ [ ]  =>, , , , ,, ,, => , , , , , , , , , , , , , , [][][][][] , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }
    %{ [ ]  =>, , , , ,, ,, => , , , , , , , , , , , , , , [][][][][] , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }
    %{ [ ]  =>, , , , ,, ,, => , , , , , , , , , , , , , , [][][][][] , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }
    %{ [ ]  =>, , , , ,, ,, => , , , , , , , , , , , , , , [][][][][] , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }
    %{ [ ]  =>, , , , ,, ,, => , , , , , , , , , , , , , , [][][][][] , , , , ] ] ] ] ] ] ] [ [ [ [ [ ] ] ] ] ][ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ [ => }
    """


    list = [ str1, str2, str3, str1, str2, str3, str4, str4 ]
    prev = System.monotonic_time(:microsecond)

    Enum.each(0..100, fn i ->
      Enum.each(list, fn(str) ->
        result = Tokenize.tokenize(str)
        #IO.inspect(result)
      end)
    end)

    next = System.monotonic_time(:microsecond)
    diff = next - prev
    IO.puts "Time: uSec #{diff}"

  end

  def tokenize(str) do
    result = []
    final = r_tokenize(str, result)
    final = Enum.reverse(final)
  end

   # match the empty string (must be before)
  def r_tokenize("--end--", result) do
     result
  end

   def r_tokenize("", result) do
     result
   end

  def r_tokenize(str, result) do
    lex = Regex.run(~r/%{|}|\[|\]|=>|\,/, str)

    #IO.inspect(lex)

    match = case List.first(lex) do
      "%{" -> { :tk_start_hash, "%{"}
      "}" -> { :tk_end_hash,  "}" }
      "=>" -> { :tk_kv, "=>" }
      "\"" -> { :tk_quote_value, "\"" }
      "," -> { :tk_comma, "," }
      "#" -> { :tk_object_value,  "#"  }
      "[" -> { :tk_start_array,  "["  }
      "]" -> { :tk_end_array, "]"  }
      _ ->  { :tk_done, "_" }
    end

    { token, matcher } = match

    case token do
      :tk_done ->
       r_tokenize("--end--", [ result | match ])
      _ ->
        base = String.length(matcher)
        {_, str_out} = String.split_at(str, base)
        r_tokenize(String.trim_leading(str_out), [ match | result ])
     end
  end

end

Tokenize.main([])

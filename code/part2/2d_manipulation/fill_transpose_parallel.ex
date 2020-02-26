#
# fillr using transpose then split into columns and run in parallel
#
defmodule ReadExample do
  def read_file() do
    width = 1000
    prev = System.monotonic_time(:microsecond)

    # Get all the data
    #contents = File.read!("../testdata/depth.raw")
    contents = File.read!("big.raw")

    arr_arr = []
    arr_arr = read_all_rows(contents, width, width, arr_arr) #not 252

    dump(arr_arr)

    # This is backwards, rows are backwards, and the top is the bottom

    col_cols = transpose_all([], arr_arr, true)
    dump(col_cols)

    me = self
    pid_list = Enum.map(col_cols, fn one_col ->
      spawn_link( fn ->
        new_col = fill_col(one_col)
        send(me, {self, new_col} )   # self is from, new_col is result
      end)
    end)
    # now they arrive in random order
    col_cols = Enum.reduce(pid_list, [], fn pid, acc_cols ->
      receive do
        { ^pid, new_col } ->
          [new_col | acc_cols]
      end
    end)


    #OLD VERSION

    #Now fill the columns, once again we flip columns and rows
    # col_cols = Enum.reduce(col_cols, [], fn one_col, acc_cols ->
    #   new_col = fill_col(one_col)
    #   [ new_col | acc_cols]
    # end)

    dump(col_cols)

    row_rows = transpose_all([], col_cols, true)
    dump(row_rows)

    # Now we are back to a complete reversed list so push in reverse order
    little16_list = Enum.reduce(row_rows, [], fn row, acc ->
      Enum.reduce(row, acc, fn v, acc ->
        [<<v::little-16>> | acc]
      end)
    end)

    dump_arr(little16_list)

    {:ok, file} = File.open("output.raw", [:write, :binary, :raw], fn file ->
      IO.binwrite(file, little16_list)
    end)

    #file.close(file)

    next = System.monotonic_time(:microsecond)

    diff = next - prev
    #if diff > 15000 do
      IO.puts "Time: uSec #{diff}"
   # end
  end

  ####


  def transpose_all(all_cols, all_rows, reverse) do
    row = hd(all_rows)
    if row == [] do
      all_cols
    else
      {one_col, rest_rows} = transpose(all_rows, [], [])
      if reverse do
        one_col = Enum.reverse(one_col)
        all_cols = [one_col | all_cols]
        transpose_all(all_cols, rest_rows, false)
      else
        all_cols = [one_col | all_cols]
        transpose_all(all_cols, rest_rows, true)
      end
    end
  end

  def transpose([], out_column, short_rows) do
    {out_column, short_rows}
  end
  # given rows or arrays, create one column, by taking the head of each row
  def transpose(rows, out_column, short_rows) do

    # take the next row from the tail
    [curr_row | rest_rows] = rows

    # get head of the current row
    [value | rest_row] = curr_row

    # save the rest_row
    short_rows = [rest_row | short_rows]

    # push it into the col
    out_column = [value | out_column]

    transpose(rest_rows, out_column, short_rows)
  end


  def dump_arr(_arr) do

  end
  def dump(_arr_arr) do

  end
  def dump_arr(arr) do
    IO.write("[")
    Enum.each(arr, fn i ->
        IO.write "#{inspect(i)} "
      end)
      IO.puts "]"
  end
  def dump(arr_arr) do
    Enum.each(arr_arr, fn arr ->
      IO.write "["
      Enum.each(arr, fn i ->
        IO.write "#{inspect(i)} "
      end)
      IO.puts "]"
    end)
    IO.puts ""
  end

  ###

  def fill_col(col) do
    {_fill_value, output} = Enum.reduce(col, {0, []}, fn pixel, {fill_value, output_arr} ->
      if pixel == 0 do
        if fill_value != 0 do
          # replace with fill_value
          output_arr = [ fill_value | output_arr]
          {fill_value, output_arr}
        else
          # pixel == 0, and fill_value == 0 so nothing we can do
          output_arr = [ 0 | output_arr]
          {fill_value, output_arr}
        end
      else
        output_arr = [ pixel | output_arr]
        fill_value = pixel  # save the fill_value
        {fill_value, output_arr}
      end
    end)
    output
  end


  ####


  def read_all_rows(_contents, _all_rows, 0, arr_arr) do
    arr_arr
  end
  def read_all_rows(contents, all_rows, row_length, arr_arr) do
    arr = []
    {row, rest} = read_row(contents, all_rows, arr)
    arr_arr = [ row | arr_arr]
    read_all_rows(rest, all_rows, row_length - 1, arr_arr)
  end

  ###

  def read_row(rest, 0, arr) do
    {arr, rest}
  end
  def read_row(contents, length, arr) do
    <<data::little-16, rest::binary>> = contents
    #IO.puts "#{inspect(data)}"
    arr = [data | arr]
    read_row(rest, length - 1, arr)
  end

  def main() do
    read_file()
  end

end

Enum.each(1..10000, fn i ->
  ReadExample.main()
end)

#
# Ilja's solution to transpose -- elegant!
#
# defmodule T do
#   def zip(ls) do
#     Enum.reverse(do_zip(ls, [], true))
#   end

#   def do_zip(src, dest, reverse?) do
#     if [] in src do
#       dest
#     else
#       {col, rows} = Enum.reduce(src, {[], []}, &reducer/2)
#       col = if reverse?, do: Enum.reverse(col), else: col
#       do_zip(rows, [col|dest], not reverse?)
#     end
#   end

#   def reducer([h|r], {col, rows}) do
#     {[h|col], [r|rows]}
#   end
# end

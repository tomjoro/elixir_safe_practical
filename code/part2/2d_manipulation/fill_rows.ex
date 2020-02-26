"""

In this version we work with rows directly and never transform

1. We keep the entire fill row around.
   -  Each iteration we update the fill row, if there are values
   - And substitute the values if there is 0 in the actual row.

So we might as well be converting them to base16 at the same time and storing that.

The end rest will be the rows in the correct order again. And we have our bottom to top fill.

Rows can't run in parallel because we wouldn't know the fill values

"""

defmodule ReadExample do
  def read_file() do
    width = 1000
    prev = System.monotonic_time(:microsecond)

    # Get all the data
    #contents = File.read!("../testdata/depth.raw")
    contents = File.read!("big.raw")

    arr_arr = []
    arr_arr = read_all_rows(contents, width, width, arr_arr) #not 252


    dump("after read", arr_arr)

    # This is backwards, rows are backwards, and the top is the bottom
    little16_list = fill_by_rows(arr_arr)

    # Now we are back to a complete reversed list so push in reverse order

    dump_arr("little_16", little16_list)

    {:ok, file} = File.open("output.raw", [:write, :binary, :raw_file_io_raw], fn file ->
      IO.binwrite(file, little16_list)
    end)

    next = System.monotonic_time(:microsecond)

    diff = next - prev
    #if diff > 15000 do
      IO.puts "Time: uSec #{diff}"
   # end
  end


  def fill_by_rows(matrix) do
    fill_one_row([], matrix, [])
  end
  def fill_one_row(output_row, [], _fill_row) do
    output_row
  end
  # the first row just creates the fill_row wihout logic
  def fill_one_row(output_row, input_rows, []) do
    [row | rest_rows ] = input_rows
    fill_row = []
    {fill_row, output_row} = Enum.reduce(row, {[], []}, fn pixel, {fill_row, output_row} ->
      fill_row = [pixel | fill_row]
      output_row = [<<pixel::little-16>> | output_row]
      {fill_row, output_row}
    end)
    #output_rows = [output_row | output_rows]

    fill_one_row(output_row, rest_rows, fill_row)
  end
  def fill_one_row(output_row, input_rows, fill_row) do    # fill_row is updated each iteration
    [row | rest_rows ] = input_rows

    {fill_row, output_fill_row, output_row} = Enum.reduce(row, {fill_row, [], output_row}, fn pixel, {rest_fill_row, output_fill_row, output_row} ->
      [fill_pixel | rest_fill] = fill_row

      # If it's 0, then use the fill_pixel for pixel (0 or not) fill_pixel is fill_pixel also
      # if it's non-zero, then just update the fill_pixel and return pixel
      pixel = if pixel == 0 do
        fill_pixel
      else
        pixel
      end

      fill_row = [pixel | fill_row]
      output_row = [<<pixel::little-16>> | output_row]
      {rest_fill, fill_row, output_row}
    end)

    #output_rows = [output_row | output_rows]
    fill_one_row(output_row, rest_rows, output_fill_row)  # the complete constructed fill_row
  end


  def dump_arr(_title, _arr) do

  end
  def dump(_title, _arr_arr) do

  end
  # def dump_arr(title, arr) do
  #   IO.puts title
  #   IO.write("[")
  #   Enum.each(arr, fn i ->
  #       IO.write "#{inspect(i)} "
  #     end)
  #     IO.puts "]"
  # end
  # def dump(title, arr_arr) do
  #   IO.puts title
  #   Enum.each(arr_arr, fn arr ->
  #     IO.write "["
  #     Enum.each(arr, fn i ->
  #       IO.write "#{inspect(i)} "
  #     end)
  #     IO.puts "]"
  #   end)
  #   IO.puts ""
  # end

  ###


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

  def read_row(rest, 0, arr) do
    {arr, rest}
  end
  def read_row(contents, length, arr) do
    <<data::little-16, rest::binary>> = contents
    #IO.puts "#{inspect(data)}"
    arr = [data | arr]
    read_row(rest, length - 1, arr)
  end

  ####

  def main() do
    read_file()
  end

end

Enum.each(1..10000, fn i ->
  ReadExample.main()
end)

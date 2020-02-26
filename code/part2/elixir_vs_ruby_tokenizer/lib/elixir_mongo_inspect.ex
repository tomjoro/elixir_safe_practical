defmodule ElixirMongoInspect do


  def start_mongo do
    # Starts the pool named MongoPool
    {:ok, _} = MongoPool.start_link(database: "test")
  end

  def find_something do
    Mongo.find(MongoPool, "users", %{})
  end

  def load_lines do
    filename = "input.txt"
    if File.exists?(filename) do
      input_file = File.open!(filename, [:read, :utf8])
      lines = IO.read(input_file, :all)
      start = %{}
      # crap this is a string!

      convert(lines, start)
    end
  end

  def convert( [head | tail], result) do
     #String.replace("#BSON.Object<", "")
    # Map.put(result, key, value)
    result = Map.put(result, "a", "b")
    convert(tail, result)
  end

  def convert([], result) do
    result
  end

  def run do
    start_mongo
    cursor = find_something
    Enum.to_list(cursor) |> IO.inspect
  end

  def run_convert do
    result = load_lines
  end
end


"""

Tokenizes the output, so that it can be converted into another
representation
  Json for Mongo console (or script)
  Ruby
  Elixir (so it can be consumed)
    - can directly produce an Elixir map, or be output to console

    If you do elixir then this is basically like a Marshall io

"""

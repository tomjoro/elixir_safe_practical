defmodule Spawn do


  def loop1(name, num) do
    #IO.puts "#{name} #{num}"
    #:timer.sleep(1000)
    loop1(name, num + 1)
  end

  def loop2(name, num) do
    IO.puts "#{name} #{num}"
    #:timer.sleep(1000)
    loop2(name, num + 1 )
  end

  def init() do
    # Spawn.loop("direct", 0)
    pid = spawn(Spawn, :loop1, ["loop1", 0])
    pid = spawn(Spawn, :loop2, ["loop2", 0])
    :timer.sleep(10000)
  end

end

Spawn.init

#  Elixir is similar, I can scall a function direct,
#  Or I can spawn and start it as a process
#  Mailboxes are built in in elixir to communicate, so I can
#  wait on any message from the routine or observe it if it
#  fails (example)

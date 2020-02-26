
defmodule Loop1 do
  def init() do
    pid = spawn(Loop2, :init, [])
    loop(pid)
  end

  def loop(pid) do
    send(pid, "Hello from loop1")
    :timer.sleep(1000)
    loop(pid)
  end
end

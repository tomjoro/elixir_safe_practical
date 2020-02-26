# TalentedLive

# Part 1
 mix phx.new talented_live --no-ecto
 mix deps.get

 mix phx.server

# Part 2 

https://hexdocs.pm/phoenix_live_view/installation.html

## Add deps in mix.exs
    {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
    {:floki, ">= 0.0.0", only: :test}


## lib/my_app_web/router.ex
    - plug: fetch_flash
    + plug :fetch_live_flash

## update the lib/talented_live_web.ex macros 

def controller do
  quote do
    ...
    import Phoenix.LiveView.Controller
  end
end

def view do
  quote do
    ...
    import Phoenix.LiveView.Helpers
  end
end

def router do
  quote do
    ...
    import Phoenix.LiveView.Router
  end
end

## lib/talented_live_web/endpoint.ex

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]]

## assets/package.json
{
  "dependencies": {
    "phoenix": "file:../deps/phoenix",
    "phoenix_html": "file:../deps/phoenix_html",
    "phoenix_live_view": "file:../deps/phoenix_live_view"
  }
}

## don't forget to install npm

cd assets && npm install

## Enable connecting in  assets/js/app.js
import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect()

## (Optional) can add to the thing assets/css/app.css

/* assets/css/app.css */
@import "../../deps/phoenix_live_view/assets/css/live_view.css";


# Part 3

## Add to lib/talented_live_web/router.ex

  scope "/", TalentedLiveWeb do
    pipe_through :browser
    live("/", CounterLive)
  end
  
## Create the controller lib/talented_live_web/controllers/talented_live.ex
defmodule TalentedLiveWeb.TalentedLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <%= @val %></h1>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :val, 0)}
  end


  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

end

defmodule TalentedLiveWeb.Router do
  use TalentedLiveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TalentedLiveWeb do
    pipe_through :browser
    live("/", TalentedLive)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TalentedLiveWeb do
  #   pipe_through :api
  # end
end

defmodule Chatty.Chat.Reactor do
  use GenServer
  def start_link do
    GenServer.start_link
  end
end

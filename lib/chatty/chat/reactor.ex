defmodule Chatty.Chat.Reactor do
  def start_link do
    Chan.start_link
  end
end

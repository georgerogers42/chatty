defmodule Chatty do
  def start(_type, _args) do
    Chatty.Supervisor.start_link
  end
end

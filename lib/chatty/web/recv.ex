defmodule Chatty.Web.Recv do
  def init(_kind, req, state) do
    {:ok, msgs} = Chatty.Chat.Reactor.get
    {:ok, req, msgs}
  end
  def handle(req, state) do
    {:ok, req} = :cowboy_req.reply(200, [{"content-type", "application/json"}], [Poison.encode!(state), "\n"], req)
    {:ok, req, state}
  end
  def terminate(_reason, _req, _state) do
    :ok
  end
end

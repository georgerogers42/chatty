defmodule Chatty.Web.Await do
  def init(_kind, req, state) do
    {:ok, req, state}
  end
  def handle(req, state) do
    {:ok, _msgs} = Chatty.Chat.Reactor.await
    {:ok, req} = :cowboy_req.reply(200, [{"content-type", "application/json"}], [Poison.encode!(%{poll: true}), "\n"], req)
    {:ok, req, state}
  end
  def terminate(_reason, _req, _state) do
    :ok
  end
end
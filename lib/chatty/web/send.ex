defmodule Chatty.Web.Send do
  def init(_kind, req, state) do
    {"POST", req} = :cowboy_req.method(req)
    {:ok, req, state}
  end
  def handle(req, state) do
    {msg, req} = :cowboy_req.qs_val("msg", req)
    :ok = Chatty.Chat.Reactor.put(msg)
    {:ok, req, state}
  end
  def terminate(_reason, _req, _state) do
    :ok
  end
end

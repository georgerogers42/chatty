defmodule Chatty.Web.Index do
  require EEx
  def init(_kind, req, state) do
    {"GET", req} = :cowboy_req.method(req)
    {room, req} = :cowboy_req.binding(:room, req)
    state = Dict.put state, :room, room
    {:ok, req, state}
  end
  def handle(req, state) do
    {:ok, req} = :cowboy_req.reply(200, [], [template(state)], req)
    {:ok, req, state}
  end
  def terminate(_reason, _req, _state) do
    :ok
  end
  EEx.function_from_file :defp, :template, "views/index.eex", [:assigns]
end

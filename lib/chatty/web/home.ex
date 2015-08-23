defmodule Chatty.Web.Home do
  require EEx
  def init(_type, req, state) do
    {:ok, req, state}
  end
  def handle(req, state) do
    {method, req} = :cowboy_req.method(req)
    handle(method, req, state)
  end
  def terminate(_reason, _req, _state) do
    :ok
  end

  defp handle("GET", req, state) do
    {:ok, req} = :cowboy_req.reply(200, [{"content-type", "text/html"}], template(state), req)
    {:ok, req, state}
  end
  defp handle("POST", req, state) do
    {:ok, vars, req} = :cowboy_req.body_qs(req)
    {:ok, room} = Enum.into(vars, HashDict.new) |> Dict.fetch("room")
    {:ok, req} = :cowboy_req.reply(302, [{"location", "/#{room}/"}], "/#{room}/", req)
    {:ok, req, state}
  end

  EEx.function_from_file :defp, :template, "views/home.eex", [:assigns]
end

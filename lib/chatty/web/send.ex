defmodule Chatty.Web.Send do
  use Timex
  def init(_kind, req, state) do
    {"POST", req} = :cowboy_req.method(req)
    {:ok, req, state}
  end
  def handle(req, state) do
    {:ok, vals, req} = :cowboy_req.body_qs(req)
    vals = vals |> Enum.into(HashDict.new)
    :ok = Chatty.Chat.Reactor.put([Date.now |> DateFormat.format!("{ISOz}"), vals["user"], vals["msg"], ])
    {:ok, req} = :cowboy_req.reply(302, [{"location", "/"}], "", req)
    {:ok, req, state}
  end
  def terminate(_reason, _req, _state) do
    :ok
  end
end

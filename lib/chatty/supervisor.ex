defmodule Chatty.Supervisor do
  use Supervisor
  def start_link(p \\ port) do
    Supervisor.start_link(__MODULE__, [p])
  end
  def init([p]) do
    children = [
      worker(Chatty.Web, [p]),
      worker(Chatty.Chat, []),
    ]
    supervise(children, strategy: :one_for_all)
  end

  defp port do
    String.to_integer(System.get_env("PORT") || "8080")
  end
end

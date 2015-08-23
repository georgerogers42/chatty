defmodule Chatty.Web do
  def routes do
    [{:_, [{"/", Chatty.Web.Home, %{}},
           {"/static/[...]", :cowboy_static, {:dir, "static"}},
           {"/:room/", Chatty.Web.Index, %{}},
           {"/:room/recv", Chatty.Web.Recv, %{}},
           {"/:room/await", Chatty.Web.Await, %{}},
           {"/:room/send", Chatty.Web.Send, %{}}]}]
  end
  def dispatch do
    :cowboy_router.compile(routes)
  end
  def start_link(port) do
    :cowboy.start_http(__MODULE__, 100, [port: port], [env: [dispatch: dispatch]])
  end
end

defmodule Chatty.Web do
  def routes do
    [
      {:_,
        [
          {"/", Chatty.Web.Index, %{}},
          {"/recv", Chatty.Web.Recv, %{}},
          {"/await", Chatty.Web.Await, %{}},
          {"/send", Chatty.Web.Send, %{}},
          {"/static/[...]", :cowboy_static, {:dir, "static"}},
        ]
      },
    ]
  end
  def dispatch do
    :cowboy_router.compile(routes)
  end
  def start_link(port) do
    :cowboy.start_http(__MODULE__, 100, [port: port], [env: [dispatch: dispatch]])
  end
end

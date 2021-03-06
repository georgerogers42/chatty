defmodule Chatty.Chat.Reactor do
  use GenServer
  defstruct await_queue: [], messages: []
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end
  def init([]) do
    {:ok, %Chatty.Chat.Reactor{}}
  end
  def handle_call(:await, from, state) do
    {:noreply, %{ state | await_queue: [from|state.await_queue] }}
  end
  def handle_call(:get, _from, state) do
    {:reply, {:ok, state.messages}, state}
  end
  def handle_call({:put, msg}, _from, state = %Chatty.Chat.Reactor{ await_queue: [] }) do
    {:reply, :ok, %{ state | messages: [msg|state.messages] }}
  end
  def handle_call({:put, msg}, _from, state) do
    msgs = [msg|state.messages]
    Enum.each(state.await_queue, &GenServer.reply(&1, {:ok, msgs}))
    {:reply, :ok, %{ state | await_queue: [], messages: [] }}
  end
  def handle_call(_msg, _from, state) do
    {:reply, {:error, :badmsg}, state}
  end

  def await(reactor, timeout \\ :infinity) do
    {:ok, _msgs} = GenServer.call(reactor, :await, timeout)
  end
  def get(reactor) do
    {:ok, _msgs} = GenServer.call(reactor, :get)
  end
  def put(reactor, msg) do
    :ok = GenServer.call(reactor, {:put, msg})
  end
end

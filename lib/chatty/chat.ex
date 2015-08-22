defmodule Chatty.Chat do
  use GenServer
  def start_link do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def init(_args) do
    {:ok, HashDict.new}
  end
  def handle_call({:room, name}, _from, state) do
    case Dict.fetch state, name do
      {:ok, room} ->
        {:reply, {:ok, room}, state}
      :error ->
        {:ok, room} = Chatty.Chat.Reactor.start_link
        state = Dict.put state, name, room
        {:reply, {:ok, room}, state}
    end
  end
  def handle_call(req, _from, state) do
    {:reply, {:error, {:badreq, req}}, state}
  end

  def room(name, ch \\ __MODULE__) do
    GenServer.call(ch, {:room, name})
  end
end

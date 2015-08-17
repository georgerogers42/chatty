defmodule Chatty.Chat.Reactor do
  use GenServer
  defstruct client_queue: []
  def start_link do
    GenServer.start_link(__MODULE__, %Chatty.Chat.Reactor{}, [name: __MODULE__])
  end
  def handle_call(:await, from, state) do
    state = %{state | client_queue: [from|state.client_queue]}
    {:no_reply, state}
  end
  def handle_call(msg, _from, state) do
    {:reply, {:error, :badmsg, msg}, state}
  end
end

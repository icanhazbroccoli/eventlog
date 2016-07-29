defmodule Listener.EpochQueue.Worker do
  use GenServer
  require Logger

  def start_link(queue) do
    Logger.debug "EpochQueue started"
    GenServer.start_link(__MODULE__, queue, name: __MODULE__)
  end

  def push(event) do
    GenServer.cast(__MODULE__, {:push, event})
  end

  def handle_cast({:push, event}, queue) do
    {:noreply, :queue.in(event, queue)}
  end

end


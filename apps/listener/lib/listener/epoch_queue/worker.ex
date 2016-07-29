defmodule Listener.EpochQueue.Worker do
  use GenServer
  require Logger

  def start_link(queue) do
    Logger.debug "EpochQueue started"
    GenServer.start_link(__MODULE__, queue, name: __MODULE__)
  end

  def push(events) do
    GenServer.cast(__MODULE__, {:push, events})
  end

  def slice_all do
    GenServer.call(__MODULE__, :slice_all)
  end

  def handle_cast({:push, events}, queue) do
    Logger.debug "EpochQueue received an epoch data"
    {:noreply, :queue.from_list(:queue.to_list(queue) ++ events)}
  end

  def handle_call(:slice_all, _from, queue) do
    {:reply, :queue.to_list(queue), :queue.new}
  end

end

defmodule Listener.Consolidator.Worker do
  use GenServer
  require Logger

  def start_link do
    Logger.debug "Consolidator worker started"
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def consolidate(data, epoch) do
    GenServer.cast(__MODULE__, {:consolidate, data, epoch})
  end

  def handle_cast({:consolidate, data, epoch}, state) do
    Logger.debug "Epoch: #{epoch}, epoch data: #{inspect data}"
    #TODO
    {:noreply, state}
  end

end


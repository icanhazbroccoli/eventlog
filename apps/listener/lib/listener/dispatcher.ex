alias Experimental.GenStage

defmodule Listener.Dispatcher do
  use GenStage
  require Logger

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Logger.debug "Dispatcher started"
    {:producer_consumer, :ok, subscribe_to: [Listener.Head.UDP],
                                dispatcher: GenStage.DemandDispatcher}
  end

  def handle_events(events, _from, state) do
    {:noreply, events, state}
  end

end

alias Experimental.GenStage

defmodule Listener.Decoder.Worker do
  use GenStage
  require Logger

  def start_link(name) do
    GenStage.start_link(__MODULE__, name)
  end

  def init(name) do
    Logger.debug "Decoder #{name} started"
    {:consumer, name, subscribe_to: [Listener.Dispatcher]}
    # {:consumer, name}
  end

  def handle_events(events, _from, name) do
    Logger.debug "#{name} received an event: #{inspect(events)}"
    #TODO: perform decoding here
    Listener.EpochQueue.Worker.push(events)
    {:noreply, [], name}
  end

end

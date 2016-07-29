alias Experimental.GenStage

defmodule Listener.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    consolidator_callback= fn epoch ->
      Listener.EpochQueue.Worker.slice_all
        |> Listener.Consolidator.Worker.consolidate(epoch)
    end
    children= [
      worker(Listener.EpochQueue.Supervisor, []),
      worker(Listener.Consolidator.Supervisor, []),
      worker(Listener.Head.Supervisor, []),
      worker(Listener.Dispatcher, []),
      worker(Listener.Decoder.Supervisor, []),
      worker(Listener.EpochTimer.Supervisor, [consolidator_callback]),
    ]
    supervise(children, strategy: :one_for_one)
  end

end

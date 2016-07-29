alias Experimental.GenStage

defmodule Listener.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children= [
      worker(Listener.EpochQueue.Supervisor, []),
      worker(Listener.Head.UDP, []),
      worker(Listener.Dispatcher, []),
      worker(Listener.Decoder.Supervisor, []),
    ]
    supervise(children, strategy: :one_for_one)
  end

end

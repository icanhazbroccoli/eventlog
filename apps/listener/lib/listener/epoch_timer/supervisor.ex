defmodule Listener.EpochTimer.Supervisor do
  use Supervisor

  def start_link(callback) do
    Supervisor.start_link(__MODULE__, callback, name: __MODULE__)
  end

  def init(callback) do
    children= [
      worker(Listener.EpochTimer.Timer, [callback]),
    ]
    supervise(children, strategy: :one_for_one)
  end

end


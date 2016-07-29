defmodule Listener.Decoder.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children= [
      worker(Listener.Decoder.Worker, [:decoder1], id: :decoder1),
      worker(Listener.Decoder.Worker, [:decoder2], id: :decoder2),
      worker(Listener.Decoder.Worker, [:decoder3], id: :decoder3),
      worker(Listener.Decoder.Worker, [:decoder4], id: :decoder4),
    ]
    supervise(children, strategy: :one_for_one)
  end

end

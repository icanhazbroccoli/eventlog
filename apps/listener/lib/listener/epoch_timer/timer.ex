defmodule Listener.EpochTimer.Timer do
  use GenServer
  require Logger

  def start_link(callback) do
    GenServer.start_link(__MODULE__, callback, name: __MODULE__)
  end

  def init(callback) do
    Logger.debug "Timer started"
    schedule_tick
    {:ok, {epoch_now, callback}}
  end

  def handle_info(:tick, {epoch, callback}) do
    new_epoch= epoch_now
    case new_epoch > epoch do
      true ->
        Logger.debug "New epoch: #{new_epoch}"
        callback.(epoch)
        schedule_tick
        {:noreply, {new_epoch, callback}}
      false ->
        schedule_tick
        {:noreply, {epoch, callback}}
    end
  end

  defp epoch_now do
    :os.system_time(:seconds)
  end

  defp schedule_tick do
    Process.send_after(self(), :tick, 100)
  end

end

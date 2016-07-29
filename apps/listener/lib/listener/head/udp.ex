alias Experimental.GenStage

defmodule Listener.Head.UDP do
  use GenStage
  require Logger

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def queue_length do
    GenStage.call(__MODULE__, :queue_length)
  end

  def inspect_queue do
    GenStage.cast(__MODULE__, :inspect_queue)
  end

  def init(:ok) do
    case :gen_udp.open(5555, [:binary]) do
      {:ok, _socket} ->
        Logger.debug "UPD head started"
        #{:producer, {:queue.new, 0}, dispatcher: GenStage.DemandDispatcher}
        {:producer, {:queue.new, 0}}
      {:error, error} ->
        {:stop, error}
    end
  end

  def handle_call(:queue_length, _from, state= {queue, demand}) do
    {:reply, { :queue.len(queue), demand }, [], state}
  end

  def handle_cast(:inspect_queue, state= {queue, _demand}) do
    Logger.debug "Queue state: #{inspect queue}"
    {:noreply, [], state}
  end

  def handle_info(msg= {:udp, _socket, _ip, _port, data}, {queue, demand}) do
    Logger.debug "Received a UDP message: " <> inspect(msg)
    dispatch_events(:queue.in(data, queue), demand, [])
  end

  def handle_demand(incoming_demand, {queue, demand}) do
    Logger.debug "received handle demand: #{demand}"
    dispatch_events(queue, incoming_demand + demand, [])
  end

  defp dispatch_events(queue, demand, events) do
    with d when d > 0 <- demand,
      {item, queue}= :queue.out(queue),
      {:value, event} <- item do
        dispatch_events(queue, demand - 1, [event | events])
    else
      _ -> {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end

end

defmodule Api.Producer do
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def record_visit(event, timeout \\ 5000) do
    GenStage.call(__MODULE__, {:event, event}, timeout)
  end

  ## Callbacks

  def init(:ok) do
    {:producer, {:queue.new, 0}, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_call({:event, event}, from, {queue, pending_demand}) do
    queue = :queue.in({from, event}, queue)
    if :queue.len(queue) > 99 do
      dispatch_events(queue, pending_demand, [])
    else
      {:noreply, [], {queue, pending_demand}}
    end
  end

  def handle_demand(incoming_demand, {queue, pending_demand}) do
    dispatch_events(queue, incoming_demand + pending_demand, [])
  end

  defp dispatch_events(queue, 0, events) do
    {:noreply, Enum.reverse(events), {queue, 0}}
  end

  defp dispatch_events(queue, demand, events) do
    case :queue.out(queue) do
      {{:value, {from, event}}, queue} ->
        GenStage.reply(from, :ok)
        dispatch_events(queue, demand - 1, [event | events])
      {:empty, queue} ->
        {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end
end


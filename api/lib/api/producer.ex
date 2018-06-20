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

  def handle_call({:event, event}, _from, state) do
    # Dispatch immediately *to the buffer*
    {:reply, :ok, [event], state}
  end

  def handle_demand(_demand, state) do
    # We don't care about the demand, BroadcastDispatcher takes care of
    # sending requested amount of events downstream.
    {:noreply, [], state}
  end
end


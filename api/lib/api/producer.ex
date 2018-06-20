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
    {:producer, :state_does_not_matter, dispatcher: GenStage.BroadcastDispatcher, buffer_size: :infinity}
  end

  def handle_call({:event, event}, _from, state) do
    {:reply, :ok, [event], state}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end


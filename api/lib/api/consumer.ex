defmodule Api.Consumer do
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, %{producer: nil}, subscribe_to: [{Api.Producer, max_demand: 200}]}
  end

  def handle_subscribe(:producer, _opts, from, state) do
    Process.send_after(self(), :ask, 100)

    {:automatic, %{state | producer: from}}
  end

  def handle_events(events, _from, state) do
    Db.Repo.insert_all("visits", events)

    {:noreply, [], state}
  end
end

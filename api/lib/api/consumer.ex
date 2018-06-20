defmodule Api.Consumer do
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :state_does_not_matter, subscribe_to: [{Api.Producer, min_demand: 100, max_demand: 200}]}
  end

  def handle_subscribe(:producer, _opts, from, state) do
    {:automatic, state}
  end

  def handle_events(events, _from, state) do
    Db.Repo.insert_all("visits", events)

    {:noreply, [], state}
  end
end

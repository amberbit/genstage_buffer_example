defmodule Api.Consumer do
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [Api.Producer]}
  end

  def handle_events(events, _from, state) do
    Db.Repo.insert_all("visits", events)

    {:noreply, [], state}
  end
end

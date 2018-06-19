defmodule Api.Consumer do
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    Process.send_after(self(), :ask, 50)

    {:consumer, %{subscription: nil}, subscribe_to: [Api.Producer]}
  end

  def handle_subscribe(:producer, _opts, from, state) do
    {:automatic, %{subscription: from}}
  end

  def handle_info(:ask, state) do
    GenStage.ask(state.subscription, 100)
    Process.send_after(self(), :ask, 50)

    {:noreply, [], state}
  end

  def handle_events(events, _from, state) do
    Db.Repo.insert_all("visits", events)

    {:noreply, [], state}
  end
end

defmodule SpaceTrackRunner do
  use GenServer

  def start_link(opts) do
    IO.puts("start link SpaceTrackRunner")
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init({pull_interval, identity, password}) do
    SessionStorage.init()

    IO.puts(
      "init SpaceTrackRunner with interval: #{pull_interval} identity: #{identity} password: #{password}"
    )

    retries = 3
    SpaceTrackClient.login(identity, password, retries)
    send(SpaceTrackRunner, :pull)
    # passes this value as state to the gen server to be reused in subsequent calls
    {:ok, pull_interval}
  end

  defp schedule_next_pull(pull_interval) do
    IO.puts("scheduling next pull")
    :timer.send_after(pull_interval, :pull)
  end

  def handle_info(:pull, pull_interval) do
    IO.puts("pulling at interval: #{inspect(pull_interval)}")
    SpaceTrackClient.pull_satellite_data()
    schedule_next_pull(pull_interval)
    {:noreply, pull_interval}
  end
end

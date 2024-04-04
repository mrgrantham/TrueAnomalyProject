defmodule SpaceTrackRunner do
  use GenServer

  def start_link(opts) do
    IO.puts("start link SpaceTrackRunner")
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init({pull_interval, identity, password, satellites}) do
    # store credentials for use later on refresh of cookies
    SessionStorage.init(identity, password)
    SessionStorage.set_satellite_query_info(satellites)

    IO.puts(
      "init SpaceTrackRunner with interval: #{pull_interval} identity: #{identity} password: #{password} satellites: #{inspect(satellites)}"
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
    {:ok, satellites} = SessionStorage.get_satellite_query_info()
    SpaceTrackClient.pull_satellite_data(satellites)
    schedule_next_pull(pull_interval)
    {:noreply, pull_interval}
  end
end

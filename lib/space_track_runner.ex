defmodule SpaceTrackRunner do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init({pull_interval, identity, password, satellites}) do
    # store credentials for use later on refresh of cookies
    SessionStorage.init(identity, password)
    SatelliteRecordStorage.init(satellites)

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
    {:ok, satellites} = SatelliteRecordStorage.get_satellites()
    {:ok, satellite_data_list} = SpaceTrackClient.pull_satellite_data(satellites)

    Enum.each(satellite_data_list, fn satellite_data ->
      satellite_data["NORAD_CAT_ID"]
      |> String.to_integer()
      |> SatelliteRecordStorage.add_record(satellite_data)
    end)

    schedule_next_pull(pull_interval)
    {:noreply, pull_interval}
  end
end

defmodule SpaceTrackRunnerTest do
  use ExUnit.Case

  # credentials to use for pulling Space-Track data
  @identity "<user-email>"
  @password "<user-password>"
  # 10 second interval to pull new satellite data
  @pull_interval 1000
  # NORAD ID's for satellites to pull data on
  @satellites [41838, 37951]

  setup %{} do
    # Avoid ETS table issue when starting up in isolation with
    # `mix test --no-start test/space_track_runner_test.exs`
    {:ok, _} = Application.ensure_all_started(:hackney)

    on_exit(fn ->
      Application.stop(:hackney)
    end)
  end

  test "run and retrieve" do
    {:ok, _pid} = SpaceTrackRunner.start_link({@pull_interval, @identity, @password, @satellites})
    satellite_request_id = List.first(@satellites)
    Process.sleep(3000)
    {:ok, record} = SatelliteRecordStorage.get_record(satellite_request_id)
    assert satellite_request_id == Map.get(record, "NORAD_CAT_ID") |> String.to_integer()
  end
end

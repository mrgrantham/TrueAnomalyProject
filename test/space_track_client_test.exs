defmodule SpaceTrackClientTest do
  use ExUnit.Case

  @identity "<user-email>"
  @password "<user-password>"

  setup do
    # Avoid ETS table issue when starting up in isolation with
    # `mix test --no-start test/space_track_client_test.exs`
    {:ok, _} = Application.ensure_all_started(:hackney)

    on_exit(fn ->
      Application.stop(:hackney)
    end)
  end

  test "login and get satellite data" do
    SessionStorage.init(@identity, @password)
    SpaceTrackClient.login(@identity, @password, 2)
    satellites = [41838, 37951]

    {:ok, sat_data_list} = SpaceTrackClient.pull_satellite_data(satellites)

    sat_ids =
      Enum.map(sat_data_list, fn sat_data ->
        sat_data["NORAD_CAT_ID"] |> String.to_integer()
      end)

    assert Enum.sort(sat_ids) == Enum.sort(satellites)
  end

  test "login and fail getting satellite data" do
    SessionStorage.init(@identity, @password)
    SpaceTrackClient.login(@identity, @password, 2)
    satellites = [4_133_838, 3_793_351, 37951]

    {:ok, sat_data_list} = SpaceTrackClient.pull_satellite_data(satellites)

    sat_ids =
      Enum.map(sat_data_list, fn sat_data ->
        sat_data["NORAD_CAT_ID"] |> String.to_integer()
      end)

    IO.inspect(sat_ids)
    assert Enum.sort(sat_ids) != Enum.sort(satellites)
  end
end

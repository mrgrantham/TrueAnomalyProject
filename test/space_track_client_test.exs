defmodule SpaceTrackClientTest do
  use ExUnit.Case

  @identity "james.grantham@gmail.com"
  @password "xuTbaz-7nyxwe-dorfet"

  setup do
    # case GenServer.whereis(SessionStorage) do
    #   nil ->
    #     IO.puts("GenServer #{inspect(SessionStorage)} is not running")
    #   pid ->
    #     IO.puts("GenServer #{inspect(SessionStorage)} with pid #{inspect(pid)} is STOPPED")
    #     GenServer.stop(pid)
    # end

    {:ok, pid} = SessionStorage.start_link()
    IO.puts("Cookie Storage started for pid [#{inspect(pid)}]")

    IO.puts("This is a setup callback for #{inspect(self())}")

    on_exit(fn ->
      IO.puts(
        "This is invoked once the test is done on pid [#{inspect(pid)}]. Process: #{inspect(self())}"
      )

      GenServer.stop(pid)
    end)
  end

  test "login and get sat data" do
    SpaceTrackClient.login(@identity, @password)

    {:ok, sat_data_string} = SpaceTrackClient.pull_satellite_data()
    IO.puts("Sat Data: #{inspect(sat_data_string)}")
  end
end

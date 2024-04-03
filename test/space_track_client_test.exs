defmodule SpaceTrackClientTest do
  use ExUnit.Case

  @identity "james.grantham@gmail.com"
  @password "xuTbaz-7nyxwe-dorfet"

  test "login and get sat data" do
    SpaceTrackClient.login(@identity, @password)

    {:ok, sat_data_string} = SpaceTrackClient.get_sat_data()
    IO.puts("Sat Data: #{inspect(sat_data_string)}")
  end
end

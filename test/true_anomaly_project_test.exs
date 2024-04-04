defmodule TrueAnomalyProjectTest do
  use ExUnit.Case
  doctest TrueAnomalyProject

  test "greets the world" do
    assert TrueAnomalyProject.hello() == :world
  end

  test "try httpoisen" do
    response = TrueAnomalyProject.poisen()
    assert response.status_code == 200
    assert response.body != nil
  end

  test "try login" do
    assert {:ok, _} = SpaceTrackClient.login_and_pull()
  end

  test "try login then pull with cookie" do
  end
end

defmodule SessionStorageTest do
  use ExUnit.Case

  # setup do
  #   case GenServer.whereis(SessionStorage) do
  #     nil ->
  #       IO.puts("GenServer #{inspect(SessionStorage)} is not running")
  #     pid ->
  #       IO.puts("GenServer #{inspect(SessionStorage)} with pid #{inspect(pid)} is STOPPED")
  #       GenServer.stop(pid)
  #   end

  #   {:ok, pid} = SessionStorage.start_link()
  #   IO.puts("Cookie Storage started for pid [#{inspect(pid)}]")

  #   IO.puts("This is a setup callback for #{inspect(self())}")
  #   on_exit(fn ->
  #     IO.puts("This is invoked once the test is done on pid [#{inspect(pid)}]. Process: #{inspect(self())}")
  #     GenServer.stop(pid)
  #   end)
  # end

  # mix test command already handles starting the SessionStorage GenServer
  test "cookie server" do
    SessionStorage.init("me@place.com", "12345")
    SessionStorage.set_session_info({"cookie info"})
    {:ok, cookies} = SessionStorage.get_cookies()
    IO.puts("COOKIE: #{inspect(cookies)}")
    assert {"cookie info"} == cookies
  end
end

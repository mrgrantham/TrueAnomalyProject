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

defmodule CookieStorageTest do
  use ExUnit.Case

  # setup do
  #   case GenServer.whereis(CookieStorage) do
  #     nil ->
  #       IO.puts("GenServer #{inspect(CookieStorage)} is not running")
  #     pid ->
  #       IO.puts("GenServer #{inspect(CookieStorage)} with pid #{inspect(pid)} is STOPPED")
  #       GenServer.stop(pid)
  #   end

  #   {:ok, pid} = CookieStorage.start_link()
  #   IO.puts("Cookie Storage started for pid [#{inspect(pid)}]")

  #   IO.puts("This is a setup callback for #{inspect(self())}")
  #   on_exit(fn ->
  #     IO.puts("This is invoked once the test is done on pid [#{inspect(pid)}]. Process: #{inspect(self())}")
  #     GenServer.stop(pid)
  #   end)
  # end

  # mix test command already handles starting the CookieStorage GenServer
  test "cookie server" do
    CookieStorage.set_cookies({"cookie info"})
    cookies = CookieStorage.get_cookies()
    IO.puts("COOKIE: #{inspect(cookies)}")
    assert {"cookie info"} == cookies
  end
end

defmodule SessionStorageTest do
  use ExUnit.Case

  setup do
    {:ok, _} = Application.ensure_all_started(:tzdata)

    on_exit(fn ->
      Application.stop(:tzdata)
    end)
  end

  test "cookie setting and retrieval" do
    SessionStorage.init("me@place.com", "12345")
    SessionStorage.set_session_info(["cookie info; expires=other; other"])
    {:ok, cookies} = SessionStorage.get_cookies()
    assert ["cookie info; expires=other; other"] == cookies
  end

  test "cookie expiration" do
    SessionStorage.init("me@place.com", "12345")

    timestamp_string =
      Timex.now()
      |> Timex.shift(seconds: 20)
      |> Timex.format("{WDshort}, {0D}-{Mshort}-{YYYY} {h24}:{m}:{s} {Zname}")
      |> case do
        {:ok, formatted_string} ->
          formatted_string

        {:error, reason} ->
          IO.puts("Error: #{reason}")
          "Error: #{reason}"
      end

    SessionStorage.set_session_info(["cookie info; expires=#{timestamp_string}"])
    assert SessionStorage.expired() == false

    timestamp_string =
      Timex.now()
      |> Timex.shift(seconds: -20)
      |> Timex.format("{WDshort}, {0D}-{Mshort}-{YYYY} {h24}:{m}:{s} {Zname}")
      |> case do
        {:ok, formatted_string} ->
          formatted_string

        {:error, reason} ->
          IO.puts("Error: #{reason}")
          "Error: #{reason}"
      end

    SessionStorage.set_session_info(["cookie info; expires=#{timestamp_string}"])
    assert SessionStorage.expired() == true
  end
end

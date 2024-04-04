defmodule SpaceTrackClient do
  @moduledoc """
  The SpaceTrackClient module contains all the functions for facilitating
  login and retrieval of data from SpaceTrack REST API
  """
  alias HTTPoison

  def init(identity, password, retries) do
    SessionStorage.init(identity, password)
    login(identity, password, retries)
  end

  def login_and_pull do
    url = "https://www.space-track.org/ajaxauth/login"

    headers = [
      "Content-Type": "application/x-www-form-urlencoded",
      Accept: "application/json; Charset=utf-8"
    ]

    body =
      URI.encode_query(%{
        "identity" => "james.grantham@gmail.com",
        "password" => "xuTbaz-7nyxwe-dorfet",
        "query" =>
          "https://www.space-track.org/basicspacedata/query/class/tle_latest/ORDINAL/1/NORAD_CAT_ID/25544,36411,26871,27422/predicates/FILE,EPOCH,TLE_LINE1,TLE_LINE2/format/json"
      })

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        {:ok, response_body}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Failed with status code #{code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def extract_cookies(headers) do
    headers
    |> Enum.filter(fn {key, _value} -> String.downcase(key) == "set-cookie" end)
    |> Enum.map(fn {_key, value} -> value end)
  end

  def login(url, identity, password, retries) do
    headers = [
      "Content-Type": "application/x-www-form-urlencoded",
      Accept: "application/json; Charset=utf-8"
    ]

    body =
      URI.encode_query(%{
        "identity" => identity,
        "password" => password
      })

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body, headers: response_headers}} ->
        cookies = extract_cookies(response_headers)
        SessionStorage.set_session_info(cookies)
        {:ok, response_body}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        case retries do
          _ when retries >= 1 ->
            IO.puts("Login failed trying again. Retries left: #{retries}")
            login(identity, password, retries - 1)

          _ ->
            {:error, "Failed with status code #{code}"}
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        case retries do
          _ when retries >= 1 ->
            IO.puts("Login failed trying again. Retries left: #{retries}")
            login(identity, password, retries - 1)

          _ ->
            {:error, reason}
        end
    end
  end

  def login(identity, password, retries \\ 0) do
    url = "https://www.space-track.org/ajaxauth/login"
    login(url, identity, password, retries)
  end

  def refresh() do
    {:ok, {identity, password}} = SessionStorage.get_credentials()
    login(identity, password, 3)
  end

  def pull_satellite_data(satellites) do
    satellite_list_string = Enum.join(satellites, ",")

    satellite_data_url =
      "https://www.space-track.org/basicspacedata/query/class/tle_latest/ORDINAL/1/NORAD_CAT_ID/#{satellite_list_string}/format/json"

    if SessionStorage.expired() do
      refresh()
    end

    {:ok, cookies} = SessionStorage.get_cookies()

    # Format cookies for the HTTP header
    cookies_joined = Enum.join(cookies, "; ")

    cookie_header = [{"Cookie", cookies_joined}]

    # Make the request with the cookies included
    case HTTPoison.get(satellite_data_url, cookie_header) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body, headers: response_headers}} ->
        # retrieve the content type an ensure that we got json back from the server
        content_type =
          response_headers
          |> Enum.filter(fn {key, _value} -> String.downcase(key) == "content-type" end)
          |> Enum.map(fn {_key, value} -> value end)
          |> List.first()
          |> String.downcase()

        case content_type do
          "application/json" ->
            case Poison.decode(response_body) do
              {:ok, data} -> {:ok, data}
              {:error, _} -> {:error, response_body}
            end

          _ ->
            {:error, response_body}
        end

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Failed with status code #{code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end

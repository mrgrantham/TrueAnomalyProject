defmodule SpaceTrackClient do
  alias HTTPoison

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

    # IO.puts("Body: #{body}")

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
    # IO.puts("HEADERS: #{inspect(headers)}")
    headers
    |> Enum.filter(fn {key, _value} -> String.downcase(key) == "set-cookie" end)
    |> Enum.map(fn {_key, value} -> value end)
  end

  def login(identity, password) do
    url = "https://www.space-track.org/ajaxauth/login"

    headers = [
      "Content-Type": "application/x-www-form-urlencoded",
      Accept: "application/json; Charset=utf-8"
    ]

    body =
      URI.encode_query(%{
        "identity" => identity,
        "password" => password
      })

    IO.puts("Body: #{body}")

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body, headers: response_headers}} ->
        response_headers |> extract_cookies() |> CookieStorage.set_cookies()
        {:ok, response_body}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Failed with status code #{code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def get_sat_data do
    sat_data_url =
      "https://www.space-track.org/basicspacedata/query/class/tle_latest/ORDINAL/1/NORAD_CAT_ID/41838,37951/predicates/FILE,EPOCH,TLE_LINE0,TLE_LINE1,TLE_LINE2/format/json"

    cookies = CookieStorage.get_cookies()
    IO.puts("Cookies: #{inspect(cookies)}")

    # Format cookies for the HTTP header
    cookies_joined = Enum.join(cookies, "; ")

    cookie_header = [{"Cookie", cookies_joined}]
    IO.puts("Cookie header: #{inspect(cookie_header)}")
    # Make the request with the cookies included

    case HTTPoison.get(sat_data_url, cookie_header) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body, headers: response_headers}} ->
        # IO.puts("headers: #{inspect(response_headers)}")

        # retrieve the content type an ensure that we got json back from the server
        content_type =
          response_headers
          |> Enum.filter(fn {key, _value} -> String.downcase(key) == "content-type" end)
          |> Enum.map(fn {_key, value} -> value end)
          |> List.first()
          |> String.downcase()

        IO.puts("Content type: #{content_type}")

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

defmodule TrueAnomalyProject do
  @moduledoc """
  Documentation for `TrueAnomalyProject`.
  """

  @doc """
  Start Application
  """
  def start() do
    hello()
  end


  @doc """
  Hello world.

  ## Examples

      iex> TrueAnomalyProject.hello()
      :world

  """
  def hello do
    IO.puts("Hello #{:world}!")
    :world
  end

  @doc """

  ## Example

    iex> TrueAnomalyProject.poisen()

  """
  def poisen do
    HTTPoison.get! "https://postman-echo.com/get"
  end

end

defmodule SpaceTrackClient do
  def login do
    url = "https://www.space-track.org/ajaxauth/login"
    headers = ["Content-Type": "application/x-www-form-urlencoded","Accept": "application/json; Charset=utf-8"]
    body = URI.encode_query(%{
      "identity" => "james.grantham@gmail.com",
      "password" => "xuTbaz-7nyxwe-dorfet",
      "query" => "https://www.space-track.org/basicspacedata/query/class/tle_latest/ORDINAL/1/NORAD_CAT_ID/25544,36411,26871,27422/predicates/FILE,EPOCH,TLE_LINE1,TLE_LINE2/format/json"
    })

    IO.puts("Body: #{body}")

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        {:ok, response_body}
      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Failed with status code #{code}"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end

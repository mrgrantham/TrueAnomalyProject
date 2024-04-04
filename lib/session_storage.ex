defmodule SessionStorage do
  @moduledoc """
  The SessionStorage manages the storage and retrieval on information
  required to maintain and restore a user's session with SpaceTrack.
  Key peices of data managed here are the identity and passworkd for login,
  the current cookie as well as its expiration time.
  """
  @table_name __MODULE__

  def init(identity, password) do
    ets_options = [
      :set,
      :public,
      :named_table,
      {:read_concurrency, true},
      {:write_concurrency, true}
    ]

    :ets.new(@table_name, ets_options)
    :ets.insert(@table_name, {:credentials, {identity, password}})
    {:ok, %{}}
  end

  def extract_expiration(cookies) do
    [cookie_string] = cookies

    expiration_section =
      String.split(cookie_string, "; ")
      |> Enum.find(fn component ->
        String.starts_with?(component, "expires=")
      end)

    [_expiration_label, expiration_string | _rest] = String.split(expiration_section, "=")

    case Timex.parse(expiration_string, "{WDshort}, {0D}-{Mshort}-{YYYY} {h24}:{m}:{s} {Zname}") do
      {:ok, expiration} ->
        expiration

      {:error, reason} ->
        IO.puts("Failed to parse date because: #{reason}")
    end
  end

  def set_session_info(cookies) do
    expiration = extract_expiration(cookies)
    :ets.insert(@table_name, {:cookies, cookies})
    :ets.insert(@table_name, {:expiration, expiration})
  end

  def get_cookies() do
    case :ets.lookup(@table_name, :cookies) do
      [] -> {:error, :not_found}
      [{:cookies, cookies}] -> {:ok, cookies}
    end
  end

  def get_credentials() do
    case :ets.lookup(@table_name, :credentials) do
      [] -> {:error, :not_found}
      [{:credentials, credentials}] -> {:ok, credentials}
    end
  end

  defp get_expiration() do
    case :ets.lookup(@table_name, :expiration) do
      [] -> {:error, :not_found}
      [{:expiration, expiration}] -> {:ok, expiration}
    end
  end

  def expired() do
    {:ok, expiration} = get_expiration()
    current_time = Timex.now()
    duration = Timex.diff(expiration, current_time, :duration)
    formatted_duration = Timex.Format.Duration.Formatter.format(duration, :humanized)

    case DateTime.compare(expiration, current_time) do
      :gt ->
        IO.puts("Cookie not expired. Time left: #{formatted_duration}")
        false

      _ ->
        IO.puts("Cookies expired")
        true
    end
  end
end

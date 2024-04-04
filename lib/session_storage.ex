defmodule SessionStorage do
  # use GenServer

  @table_name __MODULE__

  def init(_ \\ []) do
    IO.puts("Creating table #{inspect(__MODULE__)}")

    ets_options = [
      :set,
      :public,
      :named_table,
      {:read_concurrency, true},
      {:write_concurrency, true}
    ]

    :ets.new(@table_name, ets_options)
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
    IO.puts("Expiration: #{expiration_string}")

    case Timex.parse(expiration_string, "{WDshort}, {0D}-{Mshort}-{YYYY} {h24}:{m}:{s} {Zname}") do
      {:ok, expiration} ->
        IO.puts("Expiration timex: #{expiration}")
        expiration

      {:error, reason} ->
        IO.puts("Failed to parse date because: #{reason}")
    end
  end

  def set_session_info(identity, password, cookies) do
    IO.puts("Getting cookies #{inspect(__MODULE__)}")
    expiration = extract_expiration(cookies)
    :ets.insert(@table_name, {:cookies, cookies})
    :ets.insert(@table_name, {:expiration, expiration})
    :ets.insert(@table_name, {:credentials, {identity, password}})
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
    current_time = DateTime.utc_now()

    case DateTime.compare(expiration, current_time) do
      :gt ->
        IO.puts("Expiration greater than current time")
        false

      :lt ->
        IO.puts("Expiration less than current time")
        true

      :eq ->
        IO.puts("Expiration equal current time... unlikely")
        true
    end
  end
end

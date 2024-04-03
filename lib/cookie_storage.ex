defmodule CookieStorage do
  use GenServer

  def start_link(cookies \\ []) do
    GenServer.start_link(__MODULE__, cookies, name: __MODULE__)
  end

  def set_cookies(cookies) do
    GenServer.call(__MODULE__, {:set_cookies, cookies})
  end

  def get_cookies() do
    GenServer.call(__MODULE__, :get_cookies)
  end

  # GenServer Callback Implemenations
  def init(cookies) do
    {:ok, cookies}
  end

  def handle_call({:set_cookies, cookies}, _from, _state) do
    {:reply, :ok, cookies}
  end

  def handle_call(:get_cookies, _from, state) do
    {:reply, state, state}
  end
end

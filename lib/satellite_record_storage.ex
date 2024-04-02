defmodule SatelliteRecordStorage do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start(__MODULE__, opts, name: __MODULE__)
  end

  def add_records(records) do
    GenServer.call(__MODULE__, {:add_records, records})
  end

  def get_records() do
    GenServer.call(__MODULE__, :get_records)
  end

  def init(opts) do
    {:ok, opts}
  end

  def handle_call({:add_records, records}, _from, _state) do
    {:reply, :ok, records}
  end

  def handle_call(:get_records, _from, state) do
    {:reply, state, state}
  end

end

defmodule SatelliteRecordStorage do
  @moduledoc """
  The SatelliteRecordStorage contains the functions used to manage the ETS table
  uses to store IDs of the satellites of interest for the Space Track queries,
  as well as the
  """
  @table_name __MODULE__
  def init(satellites) do
    ets_options = [
      :set,
      :public,
      :named_table,
      {:read_concurrency, true},
      {:write_concurrency, true}
    ]

    :ets.new(@table_name, ets_options)
    :ets.insert(@table_name, {:satellites, satellites})
    {:ok, %{}}
  end

  def get_satellites() do
    case :ets.lookup(@table_name, :satellites) do
      [] -> {:error, :not_found}
      [{:satellites, satellites}] -> {:ok, satellites}
    end
  end

  def add_record(satellite, record) do
    :ets.insert(@table_name, {satellite, record})
  end

  def get_record(satellite) do
    case :ets.lookup(@table_name, satellite) do
      [] -> {:error, :not_found}
      [{_satellite, satellite_data}] -> {:ok, satellite_data}
    end
  end

  def get_records(satellites) do
    satellites_data =
      Enum.map(satellites, fn satellite ->
        case :ets.lookup(@table_name, satellite) do
          [] -> {satellite, :not_found}
          [{satellite, satellite_data}] -> {satellite, satellite_data}
        end
      end)

    Enum.into(satellites_data, %{})
  end
end

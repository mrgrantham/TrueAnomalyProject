defmodule SatelliteRecordStorageTest do
  use ExUnit.Case

  test "store and retrieve table data" do

    SatelliteRecordStorage.add_records({:record, "a record"})
    SatelliteRecordStorage.add_records({:record, "a record"})
    record = SatelliteRecordStorage.get_records()
    IO.puts("Records: #{inspect(record)}")
  end
end

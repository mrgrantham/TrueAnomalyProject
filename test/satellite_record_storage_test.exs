defmodule SatelliteRecordStorageTest do
  use ExUnit.Case

  setup %{} do
    SatelliteRecordStorage.init([1, 2])
  end

  test "store and retrieve satellite data" do
    SatelliteRecordStorage.add_record(1, "1 record")
    SatelliteRecordStorage.add_record(2, "2 record")
    record = SatelliteRecordStorage.get_record(1)

    assert {:ok, "1 record"} == record
  end

  test "bad key" do
    record = SatelliteRecordStorage.get_record(3)
    assert {:error, :not_found} == record
  end

  test "store and retrieve multiple satellite data" do
    SatelliteRecordStorage.add_record(1, {"1 record"})
    SatelliteRecordStorage.add_record(2, {"2 record"})
    records = SatelliteRecordStorage.get_records([1, 2])

    assert {"1 record"} == Map.get(records, 1)
    assert {"2 record"} == Map.get(records, 2)
  end

  test "multiple bad keys" do
    records = SatelliteRecordStorage.get_records([3, 4])
    assert :not_found == Map.get(records, 3)
    assert :not_found == Map.get(records, 4)
  end

  test "store and retrieve multiple good and bad satellite data" do
    SatelliteRecordStorage.add_record(1, {"1 record"})
    SatelliteRecordStorage.add_record(2, {"2 record"})
    records = SatelliteRecordStorage.get_records([1, 2, 3])

    assert {"1 record"} == Map.get(records, 1)
    assert {"2 record"} == Map.get(records, 2)
    assert :not_found == Map.get(records, 3)
  end
end

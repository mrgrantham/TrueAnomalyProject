defmodule TLETest do
  use ExUnit.Case

  test "line0_parse" do
    line0_string = "0 LUCH 5A"
    line0 = %TLE.Line0{common_name: line0_string}
    assert %TLE.Line0{common_name: "0 LUCH 5A"} == line0
  end

  test "line1_parse" do
    line1_string = "1 37951U 11074B   24093.81754303 -.00000047  00000-0  00000+0 0  9998"
    line1 = TLE.Line1.parse(line1_string)
    # IO.puts("TLE.Line1 STRUCT: #{inspect(line1)}")
    assert %TLE.Line1{
             satellite_catalog_no: "37951",
             elset_classification: "U",
             international_designator: "11074B  ",
             element_set_epoch: "24093.81754303",
             derivative_1st: "-.00000047",
             derivative_2nd: " 00000-0",
             b_drag_term: " 00000+0",
             element_set_type: "0",
             element_no: " 999",
             checksum: "8"
           } == line1
  end

  test "line2_parse" do
    line2_string = "2 37951   6.6890  86.1657 0003145 302.9588 263.7072  1.00271842 45110"
    line2 = TLE.Line2.parse(line2_string)
    # IO.puts("TLE.Line2 STRUCT: #{inspect(line2)}")
    assert %TLE.Line2{
             satellite_catalog_no: "37951",
             orbit_inclination: "  6.6890",
             right_ascension: " 86.1657",
             eccentricity: "0003145",
             argument_of_pedigree: "302.9588",
             mean_anomaly: "263.7072",
             mean_motion: " 1.00271842",
             revolution_no_at_epoch: " 4511",
             checksum: "0"
           } == line2
  end

  test "tle_parse" do
    tle_map = %{
      "EPOCH" => "2024-04-02 19:37:15",
      "FILE" => "4259876",
      "TLE_LINE0" => "0 LUCH 5A",
      "TLE_LINE1" => "1 37951U 11074B   24093.81754303 -.00000047  00000-0  00000+0 0  9998",
      "TLE_LINE2" => "2 37951   6.6890  86.1657 0003145 302.9588 263.7072  1.00271842 45110"
    }

    tle = TLE.tle_from_map(tle_map)
    # IO.puts("TLE STRUCT: #{inspect(tle)}")
    assert %TLE{
             line0: "0 LUCH 5A",
             line1: %TLE.Line1{
               satellite_catalog_no: "37951",
               elset_classification: "U",
               international_designator: "11074B  ",
               element_set_epoch: "24093.81754303",
               derivative_1st: "-.00000047",
               derivative_2nd: " 00000-0",
               b_drag_term: " 00000+0",
               element_set_type: "0",
               element_no: " 999",
               checksum: "8"
             },
             line2: %TLE.Line2{
               satellite_catalog_no: "37951",
               orbit_inclination: "  6.6890",
               right_ascension: " 86.1657",
               eccentricity: "0003145",
               argument_of_pedigree: "302.9588",
               mean_anomaly: "263.7072",
               mean_motion: " 1.00271842",
               revolution_no_at_epoch: " 4511",
               checksum: "0"
             }
           } == tle
  end
end

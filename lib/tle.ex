defmodule TLE.Line0 do
  @moduledoc """
  TLE.Line0 contains the components to be populated by the Two Line Element format line 0
  """
  defstruct common_name: nil
end

defmodule TLE.Line1 do
  @moduledoc """
  TLE.Line1 contains the components to be populated by the Two Line Element format line 1
  """
  defstruct satellite_catalog_no: nil,
            elset_classification: nil,
            international_designator: nil,
            element_set_epoch: nil,
            derivative_1st: nil,
            derivative_2nd: nil,
            b_drag_term: nil,
            element_set_type: nil,
            element_no: nil,
            checksum: nil

  def parse(line_string) do
    # Since slice uses 0 indexing this all locations are n-1 from the spec
    # here https://www.space-track.org/documentation#/tle
    %TLE.Line1{
      satellite_catalog_no: String.slice(line_string, 2..6),
      elset_classification: String.slice(line_string, 7..7),
      international_designator: String.slice(line_string, 9..16),
      element_set_epoch: String.slice(line_string, 18..31),
      derivative_1st: String.slice(line_string, 33..42),
      derivative_2nd: String.slice(line_string, 44..51),
      b_drag_term: String.slice(line_string, 53..60),
      element_set_type: String.slice(line_string, 62..62),
      element_no: String.slice(line_string, 64..67),
      checksum: String.slice(line_string, 68..68)
    }
  end
end

defmodule TLE.Line2 do
  @moduledoc """
  TLE.Line2 contains the components to be populated by the Two Line Element format line 1
  """
  defstruct satellite_catalog_no: nil,
            orbit_inclination: nil,
            right_ascension: nil,
            eccentricity: nil,
            argument_of_pedigree: nil,
            mean_anomaly: nil,
            mean_motion: nil,
            revolution_no_at_epoch: nil,
            checksum: nil

  def parse(line_string) do
    # Since slice uses 0 indexing this all locations are n-1 from the spec
    # here https://www.space-track.org/documentation#/tle
    %TLE.Line2{
      satellite_catalog_no: String.slice(line_string, 2..6),
      orbit_inclination: String.slice(line_string, 8..15),
      right_ascension: String.slice(line_string, 17..24),
      eccentricity: String.slice(line_string, 26..32),
      argument_of_pedigree: String.slice(line_string, 34..41),
      mean_anomaly: String.slice(line_string, 43..50),
      mean_motion: String.slice(line_string, 52..62),
      revolution_no_at_epoch: String.slice(line_string, 63..67),
      checksum: String.slice(line_string, 68..68)
    }
  end
end

defmodule TLE do
  @moduledoc """
  TLE contains functions to combine the Two Line Element components into a single struct
  that parses the lines as defined in the spec
  https://www.space-track.org/documentation#/tle
  """
  defstruct epoch: nil, line0: %TLE.Line0{}, line1: %TLE.Line1{}, line2: %TLE.Line2{}

  def tle_from_map(tle_map) do
    %TLE{
      line0: Map.get(tle_map, "TLE_LINE0"),
      line1: Map.get(tle_map, "TLE_LINE1") |> TLE.Line1.parse(),
      line2: Map.get(tle_map, "TLE_LINE2") |> TLE.Line2.parse()
    }
  end
end

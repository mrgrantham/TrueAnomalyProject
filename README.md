# TrueAnomalyProject

## Prompt
A key element of mission planning and general space domain awareness (SDA) is knowing approximately
where things are in space. Mosaic ingests and catalogs data from different commercial providers and
from our own satellites as well.

For this task, use Space Track to track two satellites, SJ-17 (NORAD ID 41838) and Luch 5A (NORAD ID
37951). You’ll need to integrate with Spack Track’s API to query and store relevant information for the
two satellites. Then, per Space Track’s API restrictions, set up a recurring job to pull down the latest TLE
data. Then provide an API to query one or both of the satellites and then return the latest TLE data along
with relevant satellite information. This can all be done in Elixir; the state data can be stored in memory.
There’s no need or expectation that the data persist if the application is shut down.

## Components

- **TrueAnomalyProject** - Application to faciliate startup of StarTrackRunner GenServer
- **SpaceTrackRunner** - Implements Genserver callbacks and manages timed retrieval and storage from server
- **SpaceTrackClient** - Contains functions relating to authentication and querying the Space Track server
- **SessionStorage** - Manages session related data such as expiration and credentials
- **SatelliteRecordStorage** - Manages storage and retrieval of satellite TLE+ data
- **TLE** - *(Unused)* Handles parsing of TLE format to Elixir struct

## Usage

The app as a whole can be tested via `iex -S mix` and requesting data using `SatelliteRecordStorage.get_record(<NORAD_CAT_ID>)` or `SatelliteRecordStorage.get_records([<NORAD_CAT_ID1>,<NORAD_CAT_ID1>,...])`. The ID must be one that was already provided when starting up the SpaceTrackRunner GenServer.

## Testing

Tests are run with `mix test --no-start` so that they can be tested in isolation, avoiding the entire app starting up in the background.

This also means that running `mix test` will fail as it stands, as it would casue some reasouces (like ETS tables) to attempt to be created twice, resulting in an error. Please avoid using it.

### Additional Features to add ###
- Additional validation of messages/parsing/etc at every step of the REST APIs interaction and parsing
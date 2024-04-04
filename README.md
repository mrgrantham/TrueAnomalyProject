# TrueAnomalyProject

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `true_anomaly_project` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:true_anomaly_project, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/true_anomaly_project>.

### Testing

Tests are run with `mix test --no-start` so they can be tested in isolation, avoiding the entire app starting up in the background

The app as a whole can be tested via `iex -S mix` and requesting data using SatelliteRecordStorage.get_satellites([<NORAD_ID>]). The ID must be one that was already provided when starting up the SpaceTrackRunner GenServer.

### Additional Features to add ###
- Additional validation of messages/parsing/etc at every step of the REST APIs interaction and parsing
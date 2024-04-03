defmodule TrueAnomalyProject do
  @moduledoc """
  Documentation for `TrueAnomalyProject`.
  """

  @doc """
  Start Application
  """
  def start(_type, _args) do
    IO.puts(hello())

    children = [
      # List of workers and supervisors to be started
      # This tells the supervisor to start CookieStore
      {CookieStorage, []},
      # This tells the supervisor to start the Satellite Data Storage
      {SatelliteRecordStorage, []}
    ]

    opts = [strategy: :one_for_one, name: TrueAnomalyProject.Supervisor]
    # Need to call this function to return a supervision tree from the start() function,
    # fullfulling the spec requirments of this function when used by the application
    Supervisor.start_link(children, opts)
  end

  @doc """
  Hello world.

  ## Examples

      iex> TrueAnomalyProject.hello()
      :world

  """
  def hello do
    IO.puts("Hello #{:world}!")
    :world
  end

  @doc """

  ## Example

    iex> TrueAnomalyProject.poisen()

  """
  def poisen do
    HTTPoison.get!("https://postman-echo.com/get")
  end
end

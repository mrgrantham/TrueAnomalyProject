defmodule TrueAnomalyProject do
  @moduledoc """
  Documentation for `TrueAnomalyProject`.
  """

  # credentials to use for pulling Space-Track data
  @identity "james.grantham@gmail.com"
  @password "xuTbaz-7nyxwe-dorfet"
  # 10 second interval to pull new satellite data
  @pull_interval 10000
  # NORAD ID's for satellites to pull data on
  @satellites [41838, 37951]

  @doc """
  Start Application
  """
  def start(_type, _args) do
    children = [
      # List of workers and supervisors to be started
      # This tells the supervisor the process that will pull satellite data
      # regularly at the given interval
      {SpaceTrackRunner, {@pull_interval, @identity, @password, @satellites}}
    ]

    opts = [strategy: :one_for_one, name: TrueAnomalyProject.Supervisor]
    # Need to call this function to return a supervision tree from the start() function,
    # fullfulling the spec requirments of this function when used by the application
    Supervisor.start_link(children, opts)
  end
end

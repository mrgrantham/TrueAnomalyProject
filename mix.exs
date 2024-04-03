defmodule TrueAnomalyProject.MixProject do
  use Mix.Project

  def project do
    [
      app: :true_anomaly_project,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # Name of any function implenting the Application behavior
      # entrypoint for application. Module must decalare a start() function
      mod: {TrueAnomalyProject, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # handle rest api requests
      {:httpoison, "~> 2.2"},
      # handle json
      {:poison, "~> 5.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

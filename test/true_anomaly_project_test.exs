defmodule TrueAnomalyProjectTest do
  use ExUnit.Case
  doctest TrueAnomalyProject

  test "greets the world" do
    assert TrueAnomalyProject.hello() == :world
  end

  test "try httpoisen" do
    assert TrueAnomalyProject.poisen() == :poisen
  end

  test "try login" do
    assert SpaceTrackClient.login() == {:ok}
  end
end

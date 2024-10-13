defmodule MongoonfireTest do
  use ExUnit.Case
  doctest Mongoonfire

  test "greets the world" do
    assert Mongoonfire.hello() == :world
  end
end

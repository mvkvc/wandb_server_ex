defmodule WandbServerExTest do
  use ExUnit.Case
  doctest WandbServerEx

  test "greets the world" do
    assert WandbServerEx.hello() == :world
  end
end

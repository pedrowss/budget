defmodule BudgetTest do
  use ExUnit.Case
  doctest Budget

  test "greets the world" do
    assert Budget.hello() == :world
  end
end

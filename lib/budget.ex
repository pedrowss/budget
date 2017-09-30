defmodule Budget do
  def list_transactions do
    File.read("lib/transactions.csv")
  end
end

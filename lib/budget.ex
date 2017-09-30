defmodule Budget do
  alias NimbleCSV.RFC4180, as: CSV

  def list_transactions do
    File.read!("lib/transactions.csv")
    |> parser
  end

  defp parser(string) do
    CSV.parse_string(string)
  end
end

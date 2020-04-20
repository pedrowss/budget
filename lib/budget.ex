defmodule Budget do
  alias NimbleCSV.RFC4180, as: CSV

  def list_transactions do
    File.read!("lib/transactions.csv")
    |> parse
    |> filter
    |> normalize
    |> sort
    |> print
  end

  defp parse(string) do
    string
    |> String.replace("\r", "")
    |> CSV.parse_string()
  end

  defp filter(rows) do
    # Enum.map(rows, fn(row) -> Enum.drop(row, 1) end)
    Enum.map(rows, &Enum.drop(&1, 1))
  end

  defp normalize(rows) do
    Enum.map(rows, &parse_amount(&1))
  end

  defp parse_amount([date, description, amount]) do
    [date, description, parse_to_float(amount)]
  end

  defp parse_to_float(string) do
    String.to_float(string)
    |> abs
  end

  defp sort(rows) do
    rows
    |> Enum.sort(&sort_asc_amount(&1, &2))
  end

  defp sort_asc_amount([_, _, prev], [_, _, next]) do
    prev < next
  end

  defp print(rows) do
    IO.puts("\nTransactions:")
    Enum.each(rows, &print_to_console(&1))
  end

  defp print_to_console([data, description, amount]) do
    amount = Budget.Conversion.from_dollar_to_real(amount)
    IO.puts("#{data} #{description} \tR$ #{:erlang.float_to_binary(amount, decimals: 2)}")
  end
end

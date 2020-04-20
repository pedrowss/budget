defmodule Budget.Conversion do
  def from_dollar_to_real(amount) do
    HTTPoison.start()
    url = "http://data.fixer.io/api/latest?access_key=#{System.get_env("ACCESS_KEY")}"

    case HTTPoison.get(url) do
      {:ok, response} -> parse(response) |> find_tax |> calculate(amount)
      {:error, _} -> "Error fetching tax rates"
    end
  end

  defp parse(%{status_code: 200, body: json_response}) do
    Poison.Parser.parse(json_response)
  end

  defp find_tax({:ok, %{"base" => _base, "date" => _date, "rates" => rates}}) do
    find_tax(rates)
  end

  defp find_tax(%{"BRL" => rate}) do
    rate
  end

  defp calculate(rate, amount) do
    amount * rate
  end
end

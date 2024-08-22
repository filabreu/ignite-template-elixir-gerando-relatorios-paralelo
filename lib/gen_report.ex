defmodule GenReport do
  alias GenReport.Parser

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(build_report(), fn line, report -> sum_hours(line, report) end)
  end

  def build do
    {:error, "Insira o nome de um arquivo"}
  end

  def months do
    @months
  end

  defp sum_hours(
    [name, hours, _day, month, year],
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    } = _report
  ) do
    %{
      "all_hours" => sum_all_hours(all_hours, name, hours),
      "hours_per_month" => sum_hours_per_month(hours_per_month, name, month, hours),
      "hours_per_year" => sum_hours_per_year(hours_per_year, name, year, hours)
    }
  end

  defp sum_all_hours(all_hours, name, hours) do
    Map.put(all_hours, name, (all_hours[name] && all_hours[name] + hours) || hours)
  end

  defp sum_hours_per_month(hours_per_month, name, month, hours) do
    get_months_hours(hours_per_month, name)
    |> add_hours_to_month(month, hours)
    |> update_montlhy_hours(hours_per_month, name)
  end

  defp get_months_hours(hours_per_month, name) do
    hours_per_month[name] || %{}
  end

  defp get_month_hours(months_hours, month) do
    months_hours[month] || 0
  end

  defp add_hours_to_month(months_hours, month, hours) do
    Map.put(months_hours, month, get_month_hours(months_hours, month) + hours)
  end

  defp update_montlhy_hours(months_hours, hours_per_month, name) do
    Map.put(hours_per_month, name, months_hours)
  end

  defp sum_hours_per_year(hours_per_year, name, year, hours) do
    get_years_hours(hours_per_year, name)
    |> add_hours_to_year(year, hours)
    |> update_yearly_hours(hours_per_year, name)
  end

  defp get_years_hours(hours_per_year, name) do
    hours_per_year[name] || %{}
  end

  defp get_year_hours(years_hours, year) do
    years_hours[year] || 0
  end

  defp add_hours_to_year(years_hours, year, hours) do
    Map.put(years_hours, year, get_year_hours(years_hours, year) + hours)
  end

  defp update_yearly_hours(years_hours, hours_per_year, name) do
    Map.put(hours_per_year, name, years_hours)
  end

  defp build_report do
    %{"all_hours" => %{}, "hours_per_month" => %{}, "hours_per_year" => %{}}
  end
end

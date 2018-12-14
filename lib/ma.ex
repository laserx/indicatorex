defmodule Indicatorex.MA do
  defstruct n: 0, v: []

  def calc(data, n \\ 5), do: run(data, n)

  defp run(data, n) when n >= 1, do: ma(data, n)
  defp run(_, n), do: {:error, "n must gte 1, now n: #{n}"}

  defp ma(data, n, resp \\ [])
  defp ma([], _, []), do: {:error, "empty"}
  defp ma([], n, resp), do: {:ok, %Indicatorex.MA{n: n, v: resp}}
  defp ma([h | t], n, []), do: ma(t, n, [%Indicatorex.MA.Sericalize{raw: h, ma: h / 1}])

  defp ma([h | t], n, resp) do
    time = window(resp, n)
    taken = -(n - 1)

    raws =
      for %Indicatorex.MA.Sericalize{raw: raw} <- Enum.take(resp, taken) do
        [] ++ raw
      end

    ma(t, n, resp ++ [%Indicatorex.MA.Sericalize{raw: h, ma: Enum.sum(raws ++ [h]) / time}])
  end

  defp window(data, n)
  defp window([], _), do: 0

  defp window(data, n) do
    case length(Enum.take(data, n)) < n - 1 do
      true -> length(Enum.take(data, -n)) + 1
      _ -> n
    end
  end
end

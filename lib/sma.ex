defmodule Indicatorex.SMA do
  defstruct n: 0, v: [%Indicatorex.SMA.Sericalize{}]

  def calc(data, n \\ 5), do: run(data, n)

  # todo: think this function, source: https://en.wikipedia.org/wiki/Moving_average#Simple_moving_average
  # def calc(close, pre_sma, pre_n_close, n), do: pre_sma + close/n - pre_n_close/n

  defp run(data, n) when n >= 1, do: sma(data, n)
  defp run(_, n), do: {:error, "n must gte 1, now n: #{n}"}

  defp sma(data, n, resp \\ [])
  defp sma([], _, []), do: {:error, "empty"}
  defp sma([], n, resp), do: {:ok, %Indicatorex.SMA{n: n, v: resp}}
  defp sma([h | t], n, []), do: sma(t, n, [%Indicatorex.SMA.Sericalize{raw: h, sma: h / 1}])

  defp sma([h | t], n, resp) do
    time = window(resp, n)
    taken = -(n - 1)

    raws =
      for %Indicatorex.SMA.Sericalize{raw: raw} <- Enum.take(resp, taken) do
        [] ++ raw
      end

    sma(t, n, resp ++ [%Indicatorex.SMA.Sericalize{raw: h, sma: Enum.sum(raws ++ [h]) / time}])
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

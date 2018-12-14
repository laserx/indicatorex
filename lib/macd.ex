defmodule Indicatorex.MACD do
  defstruct fast: 0, slow: 0, dif: 0, v: [%Indicatorex.MACD.Sericalize{}]

  def calc(data, fast \\ 12, slow \\ 26, diff \\ 9), do: run(data, fast, slow, diff)

  defp run(_, fast, slow, _) when slow <= fast and is_integer(slow + fast),
    do: {:error, "fast must less than slow"}

  defp run(data, fast, slow, diff) when is_integer(fast + slow + diff) do
    alias Indicatorex.EMA
    {:ok, %EMA{span: ^fast, v: ema_f}} = EMA.calc(data, fast)
    {:ok, %EMA{span: ^slow, v: ema_s}} = EMA.calc(data, slow)
    {:ok, dif_fs} = differ(ema_f, ema_s)
    {:ok, %EMA{span: ^diff, v: ema_d}} = EMA.calc(dif_fs, diff)

    case macd(ema_f, ema_s, ema_d) do
      {:ok, v} -> %Indicatorex.MACD{fast: fast, slow: slow, dif: diff, v: v}
      error -> error
    end
  end

  defp macd(ema_f, ema_s, ema_d, resp \\ [])
  defp macd([], [], [], []), do: {:error, "run macd empty"}
  defp macd([], [], [], resp), do: {:ok, resp}

  defp macd([fh | ft], [sh | st], [dh | dt], resp) do
    alias Indicatorex.MACD.Sericalize

    dif = fh - sh

    macd(
      ft,
      st,
      dt,
      resp ++
        [
          %Sericalize{
            ema_f: fh,
            ema_s: sh,
            dea: dh,
            dif: dif,
            macd: 2 * (dif - dh)
          }
        ]
    )
  end

  @spec differ([number()], [number()]) :: {:error, String.t()} | {:ok, [number()]}
  def differ(f, s), do: diff(f, s)

  defp diff(ema_f, ema_s, resp \\ [])

  defp diff(ema_f, ema_s, []) when length(ema_f) != length(ema_s),
    do:
      {:error,
       "faster and slower length not match, faster is #{length(ema_f)}, slower is #{length(ema_s)}"}

  defp diff([], [], []), do: {:error, "diff empty"}
  defp diff([], [], resp), do: {:ok, resp}
  defp diff([fh | ft], [sh | st], resp), do: diff(ft, st, resp ++ [fh - sh])
end

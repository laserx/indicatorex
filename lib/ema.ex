defmodule Indicatorex.EMA do
  @type t :: %Indicatorex.EMA{span: integer, v: [float]}
  defstruct span: 0, v: []

  @spec calc([number()], number()) :: {:error, String.t()} | {:ok, Indicatorex.EMA.t()}
  def calc(data, span) when span >= 1, do: run(data, span)
  def calc(_, span), do: {:error, "span value: #{span}. span must above 1"}

  @spec calc(number(), number(), number()) :: float()
  def calc(close, pre, span),
    do: (2 * close + (span - 1) * pre) / (span + 1)

  defp run(data, span, resp \\ [])
  defp run([], _span, []), do: {:error, "empty"}
  defp run([], span, resp), do: {:ok, %Indicatorex.EMA{span: span, v: resp}}
  defp run([h | t], span, []), do: run(t, span, [h / 1])

  defp run([h | t], span, resp) do
    [pre] = Enum.take(resp, -1)
    new = calc(h, pre, span)
    run(t, span, resp ++ [new])
  end
end

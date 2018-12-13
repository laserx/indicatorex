defmodule Indicatorex.EMA do
  @type t :: %Indicatorex.EMA{span: integer, v: [float]}
  defstruct span: 0, v: []

  @spec calc([number()], number()) :: {:error, :empty} | {:ok, Indicatorex.EMA.t()}
  def calc(data, span), do: run(data, span)

  @spec calc(any(), any(), any()) :: float() | {:error, String.t()}
  def calc(close, pre, span) when span >= 1, do: (2 * close + (span - 1) * pre) / (span + 1)
  def calc(_, _, span), do: {:error, "span value: #{span}. span must above 1"}

  defp run(data, span, resp \\ [])
  defp run([], _span, []), do: {:error, :empty}
  defp run([], span, resp), do: {:ok, %Indicatorex.EMA{span: span, v: resp}}
  defp run([h | t], span, []), do: run(t, span, [h / 1])

  defp run([h | t], span, resp) do
    [pre_average] = Enum.take(resp, -1)
    new_weight = 2 / (span + 1)
    new_average = h * new_weight + pre_average * (1 - new_weight)
    run(t, span, resp ++ [new_average])
  end
end

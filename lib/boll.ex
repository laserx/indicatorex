defmodule Indicatorex.BOLL do
  defstruct n: 0, k: 0, v: []

  def calc(data, n \\ 20, k \\ 2), do: [data, n, k]
end

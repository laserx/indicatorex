defmodule Indicatorex.SMA.Sericalize do
  @type t :: %Indicatorex.SMA.Sericalize{sma: number(), raw: number()}
  defstruct sma: 0, raw: 0
end

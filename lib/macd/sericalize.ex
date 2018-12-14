defmodule Indicatorex.MACD.Sericalize do
  @type t :: %Indicatorex.MACD.Sericalize{
          ema_f: number(),
          ema_s: number(),
          dea: number(),
          dif: number(),
          macd: number()
        }
  defstruct ema_f: 0, ema_s: 0, dea: 0, dif: 0, macd: 0
end

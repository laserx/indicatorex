defmodule Indicatorex.MA.Sericalize do
  @type t :: %Indicatorex.MA.Sericalize{ma: number(), raw: number()}
  defstruct ma: 0, raw: 0
end

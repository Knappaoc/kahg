defmodule Packets do
  def is_ordered(left, right)

  # Left is out of items first, order is correct
  def is_ordered([], [_ | _]), do: true

  # Right is out of items first, order is wrong
  def is_ordered([_ | _], []), do: false

  def is_ordered(left, right) when left == right, do: true

  def is_ordered([lNext | lRem], [rNext | rRem]) when lNext == rNext do
    is_ordered(lRem, rRem)
  end

  def is_ordered([lNext | _lRem], [rNext | _rRem])
      when is_integer(lNext) and is_integer(rNext) and lNext != rNext do
    lNext < rNext
  end

  # When one side is a list and the other isn't ...
  def is_ordered([lNext | lRem], right = [rNext | _rRem])
      when is_integer(lNext) and is_list(rNext) do
    is_ordered([[lNext] | lRem], right)
  end

  def is_ordered(left = [lNext | _lRem], [rNext | rRem])
      when is_list(lNext) and is_integer(rNext) do
    is_ordered(left, [[rNext] | rRem])
  end

  # Last case is that both are lists
  def is_ordered([lNext | _lRem], [rNext | _rRem]) do
    is_ordered(lNext, rNext)
  end
end

defmodule SpiralSolver do
  @moduledoc """
  Documentation for `SpiralSolver`.
  """

  @type direction :: :down | :left | :right | :up
  @type side_toggle :: :first | :second

  @doc """
  Go clockwise. Start with up
  """
  @spec next_direction(direction) :: direction
  def next_direction(:up), do: :right
  def next_direction(:right), do: :down
  def next_direction(:down), do: :left
  def next_direction(:left), do: :up

  @doc """
  Two sides per number bump so just toggle between first ane second
  """
  @spec next_side_toggle(side_toggle) :: side_toggle
  def next_side_toggle(:first), do: :second
  def next_side_toggle(:second), do: :first

  @doc """
  If on the second toggle bump the side count
  """
  @spec bump_side_count(side_toggle, integer()) :: {1, integer()}
  def bump_side_count(:first, side_count), do: {1, side_count}
  def bump_side_count(:second, side_count), do: {1, side_count + 1}

  @doc """
  Main recursive function
  """
  @spec next_xy(
          direction(),
          {integer(), integer()},
          side_toggle(),
          integer(),
          {integer(), integer()}
        ) ::
          [binary(), ...]
  def next_xy(_, {x, y}, _, _, {end_at, end_at}) do
    ["#{end_at}: (#{x}, #{y})"]
  end

  def next_xy(direction, {x, y}, {side_count, side_count}, side_toggle, {count, end_at}) do
    [
      "#{count}: (#{x}, #{y})"
      | next_xy(
          direction |> next_direction,
          bump_xy(direction, {x, y}),
          bump_side_count(side_toggle, side_count),
          side_toggle |> next_side_toggle,
          {count + 1, end_at}
        )
    ]
  end

  def next_xy(direction, {x, y}, {side_count, side_total}, side_toggle, {count, end_at}) do
    [
      "#{count}: (#{x}, #{y})"
      | next_xy(
          direction,
          bump_xy(direction, {x, y}),
          {side_count + 1, side_total},
          side_toggle,
          {count + 1, end_at}
        )
    ]
  end

  @spec bump_xy(direction(), {integer(), integer()}) :: {integer(), integer()}
  def bump_xy(:up, {x, y}), do: {x, y + 1}
  def bump_xy(:down, {x, y}), do: {x, y - 1}
  def bump_xy(:left, {x, y}), do: {x - 1, y}
  def bump_xy(:right, {x, y}), do: {x + 1, y}

  @doc """
  Accept the default of 25 or put in anther number for alternative results

  ##Examples
  iex>SpiralSolver.run
  ["1: (0, 0)", "2: (0, 1)", "3: (1, 1)", "4: (1, 0)", "5: (1, -1)", "6: (0, -1)",
  "7: (-1, -1)", "8: (-1, 0)", "9: (-1, 1)", "10: (-1, 2)", "11: (0, 2)",
  "12: (1, 2)", "13: (2, 2)", "14: (2, 1)", "15: (2, 0)", "16: (2, -1)",
  "17: (2, -2)", "18: (1, -2)", "19: (0, -2)", "20: (-1, -2)", "21: (-2, -2)",
  "22: (-2, -1)", "23: (-2, 0)", "24: (-2, 1)", "25: (-2, 2)"]
  """
  @spec run(integer()) :: [binary(), ...]
  def run(end_at \\ 25) when is_integer(end_at) do
    next_xy(:up, {0, 0}, {1, 1}, :first, {1, end_at})
  end
end

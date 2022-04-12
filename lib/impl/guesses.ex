defmodule IslandsEngine.Impl.Guesses do

  alias IslandsEngine.Impl.Coordinate

  @type state :: :hit | :miss

  @type t :: %__MODULE__{
    hits: MapSet.t(Coordinate.t),
    misses: MapSet.t(Coordinate.t)
  }

  defstruct(
    hits: MapSet.new(),
    misses: MapSet.new()
  )

  @spec new :: t
  def new() do
    %__MODULE__{}
  end

  @spec add(t, state, Coordinate.t) :: any()
  def add(guesses, _state = :hit, coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(guesses, _, coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end
end

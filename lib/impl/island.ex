defmodule IslandsEngine.Impl.Island do

  alias IslandsEngine.Impl.Coordinate

  @type island_layout :: :square | :atoll | :dot | :l_shape | :s_shape

  @type t :: %__MODULE__{
    coordinates: MapSet.t(Coordinate.t),
    hit_coordinates: MapSet.t(Coordinate.t)
  }

  defstruct(
    coordinates: MapSet.new(),
    hit_coordinates: MapSet.new()
  )

  def types(), do: [:square, :atoll, :dot, :l_shape, :s_shape]

  @spec new(island_layout, Coordinate.t) :: t
  def new(island_type, upper_left) do
    with [_|_] = offsets <- offsets(island_type), %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok, %__MODULE__{coordinates: coordinates}}
    else
      error -> error
    end
  end

  @spec overlaps?(t, t) :: boolean
  def overlaps?(existing_island, new_island), do: not MapSet.disjoint?(existing_island.coordinates, new_island.coordinates)

  @spec guess(t, Coordinate.t) :: {Guesses.state, t}
  def guess(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(island.hit_coordinates, coordinate)
        {:hit, %{island | hit_coordinates: hit_coordinates}}
      false -> {:miss, island}
    end
  end

  @spec forested?(t) :: boolean
  def forested?(island), do: MapSet.equal?(island.coordinates, island.hit_coordinates)

  defp offsets(_island_layout = :square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  defp offsets(_island_layout = :atoll),  do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  defp offsets(_island_layout = :dot), do: [{0, 0}]
  defp offsets(_island_layout = :l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offsets(_island_layout = :s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  defp offsets(_), do: {:error, :invalid_island_type}

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc -> add_coordinate(acc, upper_left, offset) end)
  end

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate}             -> {:cont, MapSet.put(coordinates, coordinate)}
      {:error, :invalid_coordinate} -> {:halt, {:error, :invalid_coordinate}}
    end
  end
end

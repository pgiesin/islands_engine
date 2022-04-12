defmodule IslandsEngine.Impl.Coordinate do

  @board_range 1..10

  @enforce_keys [:row, :col]

  @type t :: %__MODULE__{
    row: integer,
    col: integer
  }

  defstruct(
    row: 0,
    col: 0
  )

  @spec new(integer, integer) :: {:ok, t}
  def new(row, col) when row in(@board_range) and col in(@board_range) do
    {:ok, %__MODULE__{
        row: row,
        col: col
      }
    }
  end

  def new(_row, _col), do: {:error, :invalid_coordinate}
end

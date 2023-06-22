defmodule IslandsEngine.Island do
  alias IslandsEngine.{Coordinate, Island}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  defp offsets(:dot), do: [{0, 0}]
  defp offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  defp offsets(_), do: {:error, :invalid_island_type}

  defp add_coordinate(
    coordinates,
    %Coordinate(row: upper_left_row, col: upper_left_col),
    {row_offset, col_offset})
    do
      case Coordinate.new(upper_left_row + row_offset, upper_left_col + col_offset) do
        {:ok, coordinate} ->
          {:cont, MapSet.put(coordinates, coordinate)}
        {:error, :invalid_coordinate} ->
          {:halt, {:error, :invalid_coordinate}}
      end
    end
  end

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets(type), MapSet.new(), fn {offset, map} ->
      add_coordinate(acc, upper_left, offset))
  end

  def new(type, %Coordinate(row: row, col: col)), do:

    %Island{coordinates: MapSet.new(
      Enum.map(offsets(type), fn {row_offset, col_offset} ->

      Coordinate.new(row + row_offset, col + col_offset))

    ), hit_coordinates: MapSet.new()}
end

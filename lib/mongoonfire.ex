defmodule Mongoonfire do
  @moduledoc """
  Documentation for `Mongoonfire`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Mongoonfire.hello()
      :world

  """
  def hello do
    :world
  end

  def main do
    collections()
    |> Enum.map(&Task.async(fn -> Mongoonfire.Runner.analyze(&1) end))
    |> Enum.flat_map(&Task.await(&1))
  end

  defp collections do
    :database
    |> Mongo.show_collections()
    |> Enum.to_list()
  end
end

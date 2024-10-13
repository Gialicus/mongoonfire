defmodule Mongoonfire.Utils do
  @moduledoc """
  Documentation for `Mongoonfire.Utils`.
  """

  defp type_of(%BSON.ObjectId{}), do: "object_id"
  defp type_of(%DateTime{}), do: "date_time"
  defp type_of(value) when is_binary(value), do: "string"
  defp type_of(value) when is_integer(value), do: "integer"
  defp type_of(value) when is_float(value), do: "float"
  defp type_of(value) when is_boolean(value), do: "boolean"
  defp type_of(value) when is_list(value), do: "list"
  defp type_of(value) when is_map(value), do: "map"
  defp type_of(_), do: "unknown"

  def map_types(document) do
    document
    |> Map.keys()
    |> Enum.map(fn key -> {key, type_of(document[key])} end)
  end

  def map_query(key, type, value) do
    case type do
      "object_id" ->
        [%{"#{key}" => value}, %{"#{key}" => %{"$in" => [value]}}]

      "date_time" ->
        [
          %{"#{key}" => value},
          %{"#{key}" => %{"$gte" => value}},
          %{"#{key}" => %{"$lte" => value}},
          %{"#{key}" => %{"$gt" => value}},
          %{"#{key}" => %{"$lt" => value}},
          %{"#{key}" => %{"$exists" => true}}
        ]

      "string" ->
        [
          %{"#{key}" => value},
          %{"#{key}" => %{"$regex" => value}},
          %{"#{key}" => %{"$in" => [value]}},
          %{"#{key}" => %{"$exists" => true}}
        ]

      "integer" ->
        [
          %{"#{key}" => value},
          %{"#{key}" => %{"$in" => [value]}},
          %{"#{key}" => %{"$gt" => value}},
          %{"#{key}" => %{"$lt" => value}},
          %{"#{key}" => %{"$gte" => value}},
          %{"#{key}" => %{"$lte" => value}},
          %{"#{key}" => %{"$exists" => true}}
        ]

      "float" ->
        [
          %{"#{key}" => value},
          %{"#{key}" => %{"$in" => [value]}},
          %{"#{key}" => %{"$gt" => value}},
          %{"#{key}" => %{"$lt" => value}},
          %{"#{key}" => %{"$gte" => value}},
          %{"#{key}" => %{"$lte" => value}},
          %{"#{key}" => %{"$exists" => true}}
        ]

      "boolean" ->
        [%{"#{key}" => value}, %{"#{key}" => %{"$exists" => true}}]

      "list" ->
        [%{"#{key}" => value}]

      "map" ->
        [%{"#{key}" => value}]

      _ ->
        [%{"#{key}" => value}]
    end
  end
end

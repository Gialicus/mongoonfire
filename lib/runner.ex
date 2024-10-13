defmodule Mongoonfire.Runner do
  @moduledoc """
  Documentation for `Mongoonfire.Runner`.
  """

  def seed do
    :database |> Mongo.delete_many("users", %{})

    {:ok, user} =
      :database |> Mongo.insert_one("users", %{firstName: "Giali", lastName: "Coletta"})

    :database |> Mongo.delete_many("accounts", %{})

    :database
    |> Mongo.insert_one("accounts", %{
      email: "giali@giali.com",
      password: "secret",
      user: user.inserted_id
    })

    :database |> Mongo.delete_many("ballances", %{})

    :database
    |> Mongo.insert_one("ballances", %{
      createdAt: DateTime.utc_now(),
      ballance: 2000.00,
      user: user.inserted_id
    })

    :database |> Mongo.delete_many("metas", %{})

    :database
    |> Mongo.insert_one("metas", %{
      point: 10,
      tags: ["elixir", "mongodb", "phoenix"],
      user: user.inserted_id
    })
  end

  def analyze(collection) do
    doc =
      :database
      |> Mongo.find_one(collection, %{})

    Mongoonfire.Utils.map_types(doc)
    |> Enum.flat_map(fn {key, type} ->
      queries = Mongoonfire.Utils.map_query(key, type, doc[key])

      tasks =
        Enum.map(queries, fn query ->
          Task.async(fn -> run_query(collection, query) end)
        end)

      Enum.map(tasks, &Task.await(&1))
    end)
  end

  def run_query(collection, query) do
    start_time = :os.system_time(:millisecond)
    Mongo.find_one(:database, collection, query)
    end_time = :os.system_time(:millisecond)
    execution_time = end_time - start_time

    "Collection: #{collection} - Query: #{inspect(query)} - Execution Time: #{execution_time} ms"
  end
end

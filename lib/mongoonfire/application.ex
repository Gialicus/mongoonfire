defmodule Mongoonfire.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {
        Mongo,
        [name: :database, database: database(), pool_size: 3]
      }
    ]

    opts = [strategy: :one_for_one, name: Mongoonfire.Supervisor]

    Logger.info("The database has started...")
    Supervisor.start_link(children, opts)
  end

  defp database, do: Application.get_env(:mongoonfire, :database, "mongoonfire")
end

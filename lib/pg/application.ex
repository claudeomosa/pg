defmodule PG.Application do
  use Application
  require Logger

  @impl true
  def start(_start_type, _start_args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: PG.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: PG.Supervisor]
    Logger.info("Starting Pg application...")
    Supervisor.start_link(children, opts)
  end
end

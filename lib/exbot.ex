defmodule Exbot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Exbot.Slack, [])
    ]

    opts = [strategy: :one_for_one, name: Exbot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

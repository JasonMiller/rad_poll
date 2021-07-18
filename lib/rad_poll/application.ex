defmodule RadPoll.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      RadPoll.Repo,
      # Start the Telemetry supervisor
      RadPollWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RadPoll.PubSub},
      # Start the Endpoint (http/https)
      RadPollWeb.Endpoint
      # Start a worker by calling: RadPoll.Worker.start_link(arg)
      # {RadPoll.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RadPoll.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RadPollWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

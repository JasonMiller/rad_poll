defmodule RadPoll.Repo do
  use Ecto.Repo,
    otp_app: :rad_poll,
    adapter: Ecto.Adapters.Postgres
end

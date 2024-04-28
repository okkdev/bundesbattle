defmodule Bundesbattle.Repo do
  use Ecto.Repo,
    otp_app: :bundesbattle,
    adapter: Ecto.Adapters.SQLite3
end

defmodule BundesbattleWeb.RuleController do
  use BundesbattleWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end

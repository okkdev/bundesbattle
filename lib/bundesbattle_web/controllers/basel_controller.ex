defmodule BundesbattleWeb.BaselController do
  use BundesbattleWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end

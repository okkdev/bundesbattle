defmodule BundesbattleWeb.Plugs.SEO do
  import Plug.Conn

  alias BundesbattleWeb.SEO

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :seo, SEO.new() |> SEO.build())
  end
end

defmodule BundesbattleWeb.ManageLive do
  use BundesbattleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.link href={~p"/manage/users"}>
      <.button>
        Manage Users
      </.button>
    </.link>

    <.link href={~p"/manage/tournaments"}>
      <.button>
        Manage Tournaments
      </.button>
    </.link>
    """
  end
end

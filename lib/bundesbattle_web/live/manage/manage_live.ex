defmodule BundesbattleWeb.Manage.ManageLive do
  use BundesbattleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.link href={~p"/manage/tournaments"}>
      <.button>
        Manage Tournaments
      </.button>
    </.link>

    <.link href={~p"/manage/users"}>
      <.button>
        Manage Users
      </.button>
    </.link>

    <.link href={~p"/manage/regions"}>
      <.button>
        Manage Regions
      </.button>
    </.link>

    <.link href={~p"/manage/locations"}>
      <.button>
        Manage Locations
      </.button>
    </.link>
    """
  end
end

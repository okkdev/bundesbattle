defmodule BundesbattleWeb.Manage.TournamentLive.Index do
  use BundesbattleWeb, :live_view

  alias Bundesbattle.Events
  alias Bundesbattle.Regions
  alias Bundesbattle.Events.Tournament

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tournaments, Events.list_tournaments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tournament")
    |> assign(:locations, Regions.list_locations())
    |> assign(:tournament, Events.get_tournament!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tournament")
    |> assign(:locations, Regions.list_locations())
    |> assign(:tournament, %Tournament{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tournaments")
    |> assign(:tournament, nil)
  end

  @impl true
  def handle_info(
        {BundesbattleWeb.Manage.TournamentLive.FormComponent, {:saved, tournament}},
        socket
      ) do
    {:noreply, stream_insert(socket, :tournaments, tournament)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tournament = Events.get_tournament!(id)
    {:ok, _} = Events.delete_tournament(tournament)

    {:noreply, stream_delete(socket, :tournaments, tournament)}
  end
end

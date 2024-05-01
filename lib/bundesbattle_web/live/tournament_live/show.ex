defmodule BundesbattleWeb.TournamentLive.Show do
  use BundesbattleWeb, :live_view

  alias Bundesbattle.Events
  alias Bundesbattle.Accounts

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(users: Accounts.list_users())
      |> assign(player_form: to_form(Events.change_tournament_player(%Events.TournamentPlayer{})))

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tournament, Events.get_tournament!(id))
     |> stream(:players, Events.list_tournament_players_for_tournament(id))}
  end

  @impl true
  def handle_event("save", %{"tournament_player" => tp_params}, socket) do
    case Events.create_tournament_player(
           Map.put(tp_params, "tournament_id", socket.assigns.tournament.id)
         ) do
      {:ok, player} ->
        {:noreply,
         socket
         |> stream_insert(:players, Events.preload_tournament_player(player))
         |> put_flash(:info, "Added player")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :player_form, to_form(changeset))}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tp = Events.get_tournament_player!(id)
    {:ok, _} = Events.delete_tournament_player(tp)

    {:noreply, stream_delete(socket, :players, tp)}
  end

  defp page_title(:show), do: "Show Tournament"
  defp page_title(:edit), do: "Edit Tournament"
end

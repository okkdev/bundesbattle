defmodule BundesbattleWeb.TournamentLive do
  use BundesbattleWeb, :live_view

  alias Bundesbattle.Events

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-3xl">
      <h1 class="text-4xl font-stencil"><%= @tournament.name %></h1>
      <h3 class="text-2xl font-stencil">
        <%= Calendar.strftime(@tournament.datetime, "%d.%m.%Y %H:%M") %>
      </h3>
      <.game_logo game={@tournament.game} class="h-8" />

      <div class="my-8 font-semibold text-lg">
        Bracket:
        <.link href={@tournament.bracket_link} class="text-brand">
          <%= @tournament.bracket_link %>
        </.link>
      </div>

      <p :if={@tournament.description} class="text-md">
        <%= @tournament.description %>
      </p>
    </div>

    <%= if (not is_nil(@tournament.location.latitude)) and (not is_nil(@tournament.location.longitude)) do %>
      <div
        id="map"
        phx-hook="Map"
        data-lat={@tournament.location.latitude}
        data-lng={@tournament.location.longitude}
        phx-update="ignore"
        class="w-full h-80 mt-16 rounded-md shadow"
      >
        <a href={@tournament.location.url}>
          <div class="flex flex-col">
            <span><b><%= @tournament.location.name %></b></span>
            <span><%= @tournament.location.address %></span>
            <span><%= @tournament.location.zip %> <%= @tournament.location.city %></span>
          </div>
        </a>
      </div>
    <% else %>
      <a href={@tournament.location.url}>
        <div class="flex flex-col">
          <span><b><%= @tournament.location.name %></b></span>
          <span><%= @tournament.location.address %></span>
          <span><%= @tournament.location.zip %> <%= @tournament.location.city %></span>
        </div>
      </a>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"tournament_id" => tournament_id}, _url, socket) do
    tournament = Events.get_tournament!(tournament_id)

    {:noreply, assign(socket, tournament: tournament)}
  end
end

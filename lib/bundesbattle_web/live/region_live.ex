defmodule BundesbattleWeb.RegionLive do
  use BundesbattleWeb, :live_view

  alias Bundesbattle.Regions
  alias Bundesbattle.Leaderboard

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center mb-20">
      <div class="relative">
        <h1 class="text-5xl font-stencil text-gray-950 uppercase"><%= @region.name %></h1>
        <img
          src="/images/splash.svg"
          class="absolute top-1/2 left-1/2 -translate-y-1/2 -translate-x-1/2 scale-150 w-56 -rotate-3 -z-10"
        />
      </div>
    </div>

    <h2 class="font-stencil text-3xl mb-5">Tournaments</h2>
    <%= if not Enum.empty?(@upcoming_tournaments) do %>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        <.tournament_card :for={tournament <- @upcoming_tournaments} tournament={tournament} />
      </div>
    <% else %>
      <div class="">
        No scheduled Tournaments.
      </div>
    <% end %>

    <%= if not Enum.empty?(@past_tournaments) do %>
      <h3 class="font-stencil text-2xl my-5">Past Tournaments</h3>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5 opacity-50">
        <.tournament_card :for={tournament <- @past_tournaments} tournament={tournament} />
      </div>
    <% end %>

    <h2 class="font-stencil text-3xl mb-5 mt-12">Leaderboard</h2>
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
      <.leaderboard game={:streetfighter} placements={@leaderboard[:streetfighter]} />

      <.leaderboard game={:tekken} placements={@leaderboard[:tekken]} />
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"region" => region_slug}, _url, socket) do
    region =
      Regions.get_region_by_slug!(region_slug)

    tournaments =
      region.locations
      |> Enum.flat_map(& &1.tournaments)

    upcoming_tournaments =
      tournaments
      |> Enum.filter(&(NaiveDateTime.compare(&1.datetime, NaiveDateTime.utc_now()) != :lt))

    past_tournaments = tournaments -- upcoming_tournaments

    leaderboard = [
      streetfighter: Leaderboard.create(tournaments, :streetfighter),
      tekken: Leaderboard.create(tournaments, :tekken)
    ]

    {:noreply,
     assign(socket,
       region: region,
       upcoming_tournaments: upcoming_tournaments,
       past_tournaments: past_tournaments,
       leaderboard: leaderboard
     )}
  end
end

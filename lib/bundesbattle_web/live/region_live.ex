defmodule BundesbattleWeb.RegionLive do
  use BundesbattleWeb, :live_view

  alias Bundesbattle.Regions
  alias Bundesbattle.Leaderboard
  alias BundesbattleWeb.SEO

  @bundesbattle_season 3

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center mb-20">
      <div class="relative">
        <h1 class="text-5xl uppercase font-stencil text-gray-950"><%= @region.name %></h1>
        <img
          src="/images/splash.svg"
          class="absolute top-1/2 left-1/2 w-56 scale-150 -rotate-3 -translate-x-1/2 -translate-y-1/2 -z-10"
        />
      </div>
    </div>

    <h2 class="mb-5 text-3xl font-stencil">Tournaments</h2>
    <%= if not Enum.empty?(@upcoming_tournaments) do %>
      <div class="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-3">
        <.tournament_card :for={tournament <- @upcoming_tournaments} tournament={tournament} />
      </div>
    <% else %>
      <div class="">
        No scheduled Tournaments.
      </div>
    <% end %>

    <%= if not Enum.empty?(@past_tournaments) do %>
      <h3 class="my-5 text-2xl font-stencil">Past Tournaments</h3>
      <div class="grid grid-cols-1 gap-5 opacity-50 md:grid-cols-2 lg:grid-cols-3">
        <.tournament_card :for={tournament <- @past_tournaments} tournament={tournament} />
      </div>
    <% end %>

    <h2 class="mt-12 mb-5 text-3xl font-stencil">Leaderboard</h2>
    <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
      <.leaderboard game={:streetfighter} placements={@leaderboard[:streetfighter]} />

      <.leaderboard game={:tekken} placements={@leaderboard[:tekken]} />

      <.leaderboard game={:guiltygear} placements={@leaderboard[:guiltygear]} />
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [seo: nil]}
  end

  @impl true
  def handle_params(%{"region" => region_slug}, _url, socket) do
    case Regions.get_region_by_slug(region_slug) do
      nil ->
        {:noreply, push_navigate(socket, to: "/")}

      region ->
        tournaments =
          region.locations
          |> Enum.flat_map(& &1.tournaments)
          |> Enum.filter(&(&1.bundesbattle_season == @bundesbattle_season))
          |> Enum.sort(&(NaiveDateTime.compare(&1.datetime, &2.datetime) == :lt))

        upcoming_tournaments =
          tournaments
          |> Enum.filter(&(NaiveDateTime.compare(&1.datetime, NaiveDateTime.utc_now()) == :gt))

        past_tournaments = tournaments -- upcoming_tournaments

        leaderboard = [
          streetfighter: Leaderboard.create(tournaments, :streetfighter),
          tekken: Leaderboard.create(tournaments, :tekken),
          guiltygear: Leaderboard.create(tournaments, :guiltygear)
        ]

        seo =
          %{
            title: "#{region.name} - BundesBattle Season 2 Region",
            description: "Collect points for this Season of BundesBattle in #{region.name}!",
            url: ~p"/region/#{region.slug}"
          }
          |> SEO.new()
          |> SEO.build()

        {:noreply,
         assign(socket,
           region: region,
           upcoming_tournaments: upcoming_tournaments,
           past_tournaments: past_tournaments,
           leaderboard: leaderboard,
           seo: seo
         )}
    end
  end
end

defmodule BundesbattleWeb.RegionLive do
  use BundesbattleWeb, :live_view

  alias Bundesbattle.Regions

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
    <%= if not Enum.empty?(@tournaments) do %>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        <.link
          :for={tournament <- @tournaments}
          navigate={"/tournament/#{tournament.id}"}
          class="rounded-lg border border-white/50 py-5 px-6 flex flex-col items-start hover:bg-white/10"
        >
          <h2 class="text-xl font-bold"><%= tournament.name %></h2>
          <div class="text-lg"><%= Calendar.strftime(tournament.datetime, "%d.%m.%Y %H:%M") %></div>
          <div class="text-lg flex-auto font-semibold">@<%= tournament.location.name %></div>
          <.game_logo game={tournament.game} class="h-5 mt-5" />
        </.link>
      </div>
    <% else %>
      <div class="">
        No scheduled Tournaments.
      </div>
    <% end %>

    <h2 class="font-stencil text-3xl mb-5 mt-12">Leaderboard</h2>
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
      <div class="p-3 rounded-lg border border-white/20 flex flex-col">
        <.game_logo game={:streetfighter} class="h-8 mb-4" />

        <table class="min-w-full divide-y divide-white/70 flex-auto">
          <thead>
            <tr>
              <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold sm:pl-0">
                Place
              </th>
              <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold">
                Player
              </th>
              <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold">
                Points
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-800">
            <tr>
              <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium sm:pl-0">1st</td>
              <td class="whitespace-nowrap px-3 py-4 text-sm">coolermann</td>
              <td class="whitespace-nowrap px-3 py-4 text-sm">points</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="px-3">
        <.game_logo game={:tekken} class="h-8" />
      </div>
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

    {:noreply, assign(socket, region: region, tournaments: tournaments)}
  end
end

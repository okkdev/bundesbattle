defmodule BundesbattleWeb.TournamentLive do
  use BundesbattleWeb, :live_view

  alias Bundesbattle.Events
  alias Bundesbattle.Leaderboard
  alias BundesbattleWeb.SEO

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-3xl">
      <div class="flex justify-between">
        <h1 class="text-4xl font-stencil"><%= @tournament.name %></h1>
        <.link
          :if={@current_user && @current_user.role in [:organizer, :admin]}
          navigate={~p"/manage/tournaments/#{@tournament.id}"}
        >
          <.button>
            Manage
          </.button>
        </.link>
      </div>
      <h3 class="text-2xl font-stencil">
        <%= Calendar.strftime(@tournament.datetime, "%a, %d %B %Y %H:%M") %>
      </h3>
      <.game_logo game={@tournament.game} class="h-8" />
      <.link navigate={~p"/region/#{@tournament.location.region.slug}"} class="font-semibold text-lg">
        Leaderboard: <%= @tournament.location.region.name %>
      </.link>

      <div :if={@tournament.bracket_link} class="my-8 font-semibold text-lg">
        Bracket:
        <.link href={@tournament.bracket_link} class="text-brand">
          <%= @tournament.bracket_link %>
        </.link>
      </div>

      <p :if={@tournament.description} class="text-md">
        <%= @tournament.description %>
      </p>

      <%= if not Enum.empty?(@tournament.players) do %>
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
            <tr :for={player <- @tournament.players}>
              <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium sm:pl-0">
                <%= player.placement %>
              </td>
              <td class="whitespace-nowrap px-3 py-4 text-sm">
                <div class="flex items-center gap-x-4">
                  <%= if player.user.canton do %>
                    <img
                      src={"/images/wappen/#{player.user.canton}.svg"}
                      alt={player.user.canton |> Atom.to_string() |> String.upcase()}
                      class="h-6 w-6"
                    />
                  <% else %>
                    <div class="h-6 w-6"></div>
                  <% end %>
                  <%= display_or_username(player.user) %>
                </div>
              </td>
              <td class="whitespace-nowrap px-3 py-4 text-sm">
                <%= Leaderboard.assign_points(player) %>
              </td>
            </tr>
          </tbody>
        </table>
      <% end %>
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
    {:ok, socket, temporary_assigns: [seo: nil]}
  end

  @impl true
  def handle_params(%{"tournament_id" => tournament_id}, _url, socket) do
    tournament = Events.get_tournament!(tournament_id)

    seo =
      %{
        title: "#{tournament.name} - BundesBattle Season 2 Tournament",
        description: """
        #{Calendar.strftime(tournament.datetime, "%a, %d %B %Y %H:%M")}
        Join the #{game_to_string(tournament.game)} tournament at #{tournament.location.name} to collect points for the #{tournament.location.region.name} region.
        """,
        url: ~p"/tournament/#{tournament.id}"
      }
      |> SEO.new()
      |> SEO.build()

    {:noreply, assign(socket, tournament: tournament, seo: seo)}
  end

  defp game_to_string(game) do
    case game do
      :streetfighter -> "Street Fighter 6"
      :tekken -> "Tekken 8"
    end
  end
end

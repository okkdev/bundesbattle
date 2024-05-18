defmodule BundesbattleWeb.Components do
  use Phoenix.Component

  attr :game, :atom,
    required: true,
    values: Ecto.Enum.values(Bundesbattle.Events.Tournament, :game)

  attr :class, :string, default: nil

  def game_logo(assigns) do
    {image_path, alt} =
      case assigns.game do
        :streetfighter ->
          {"/images/sf6-logo.svg", "Street Fighter 6"}

        :tekken ->
          {"/images/tekken8-light-logo.svg", "Tekken 8"}

        game ->
          {nil,
           game
           |> Atom.to_string()
           |> String.capitalize()}
      end

    assigns =
      assigns
      |> assign(image_path: image_path)
      |> assign(alt: alt)

    ~H"""
    <%= if @image_path do %>
      <img src={@image_path} alt={@alt} class={@class} />
    <% else %>
      <div class={@class}><%= @alt %></div>
    <% end %>
    """
  end

  attr :game, :atom,
    required: true,
    values: Ecto.Enum.values(Bundesbattle.Events.Tournament, :game)

  attr :placements, :list, required: true

  attr :class, :string, default: nil

  def leaderboard(assigns) do
    ~H"""
    <div class={["p-3 rounded-lg border border-white/20 flex flex-col", @class]}>
      <.game_logo game={:streetfighter} class="h-8 mb-4" />

      <%= if not Enum.empty?(@placements) do %>
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
            <tr :for={player <- @placements}>
              <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium sm:pl-0">
                <%= player.place %>
              </td>
              <td class="whitespace-nowrap px-3 py-4 text-sm"><%= player.player.username %></td>
              <td class="whitespace-nowrap px-3 py-4 text-sm"><%= player.points %></td>
            </tr>
          </tbody>
        </table>
      <% else %>
        <div class="text-center my-5">
          No player on the leaderboard
        </div>
      <% end %>
    </div>
    """
  end

  attr :tournament, Bundesbattle.Events.Tournament, required: true

  def tournament_card(assigns) do
    ~H"""
    <.link
      navigate={"/tournament/#{@tournament.id}"}
      class="rounded-lg border bg-gray-900/50 border-white/50 py-5 px-6 flex flex-col items-start hover:bg-white/10"
    >
      <h2 class="text-xl font-bold"><%= @tournament.name %></h2>
      <div class="text-lg"><%= Calendar.strftime(@tournament.datetime, "%d.%m.%Y %H:%M") %></div>
      <div class="text-lg flex-auto font-semibold">@<%= @tournament.location.name %></div>
      <.game_logo game={@tournament.game} class="h-5 mt-5" />
    </.link>
    """
  end
end

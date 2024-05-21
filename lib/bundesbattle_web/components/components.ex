defmodule BundesbattleWeb.Components do
  alias Bundesbattle.Accounts.User
  use Phoenix.Component

  slot :inner_block

  def footer(assigns) do
    ~H"""
    <footer class="py-28 mt-16 text-sm text-center bg-neutral-950">
      <h2 id="footer-heading" class="sr-only">Footer</h2>

      <div class="flex gap-8 justify-center items-center mb-8">
        <.link href="https://discord.gg/yW6e42Mx6W" class="size-6 flex items-center">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 127.14 96.36">
            <path
              fill="#fff"
              d="M107.7,8.07A105.15,105.15,0,0,0,81.47,0a72.06,72.06,0,0,0-3.36,6.83A97.68,97.68,0,0,0,49,6.83,72.37,72.37,0,0,0,45.64,0,105.89,105.89,0,0,0,19.39,8.09C2.79,32.65-1.71,56.6.54,80.21h0A105.73,105.73,0,0,0,32.71,96.36,77.7,77.7,0,0,0,39.6,85.25a68.42,68.42,0,0,1-10.85-5.18c.91-.66,1.8-1.34,2.66-2a75.57,75.57,0,0,0,64.32,0c.87.71,1.76,1.39,2.66,2a68.68,68.68,0,0,1-10.87,5.19,77,77,0,0,0,6.89,11.1A105.25,105.25,0,0,0,126.6,80.22h0C129.24,52.84,122.09,29.11,107.7,8.07ZM42.45,65.69C36.18,65.69,31,60,31,53s5-12.74,11.43-12.74S54,46,53.89,53,48.84,65.69,42.45,65.69Zm42.24,0C78.41,65.69,73.25,60,73.25,53s5-12.74,11.44-12.74S96.23,46,96.12,53,91.08,65.69,84.69,65.69Z"
            />
          </svg>
        </.link>
        <.link class="underline" href="https://season1.bundesbattle.ch">Season 1</.link>
      </div>

      <p>STREET FIGHTER™ 6 and the STREET FIGHTER™ 6 logo are trademarks of CAPCOM CO., LTD.</p>
      <p>TEKKEN™ 8 and the TEKKEN™ 8 logo are trademarks of BANDAI NAMCO ENTERTAINMENT INC.</p>

      <%= render_slot(@inner_block) %>
    </footer>
    """
  end

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

  attr :game, :atom, values: Ecto.Enum.values(Bundesbattle.Events.Tournament, :game)
  attr :placements, :list, required: true
  attr :class, :string, default: nil

  def leaderboard(assigns) do
    ~H"""
    <div class={["p-3 rounded-lg border border-white/20 flex flex-col", @class]}>
      <.game_logo :if={assigns[:game]} game={@game} class="h-8 mb-4" />

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
                <div class="font-stencil text-xl">
                  <%= player.place %>
                </div>
              </td>
              <td class="whitespace-nowrap px-3 py-4 text-sm">
                <div class="flex items-center gap-x-4">
                  <%= if player.player.canton do %>
                    <img
                      src={"/images/wappen/#{player.player.canton}.svg"}
                      alt={player.player.canton |> Atom.to_string() |> String.upcase()}
                      class="h-6 w-6"
                    />
                  <% else %>
                    <div class="h-6 w-6"></div>
                  <% end %>

                  <div class="text-lg font-medium"><%= display_or_username(player.player) %></div>
                </div>
              </td>
              <td class="whitespace-nowrap px-3 py-4 text-sm">
                <div class="font-stencil text-lg">
                  <%= player.points %>
                </div>
              </td>
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

  def display_or_username(%User{} = user) do
    case user.display_name do
      nil -> user.username
      dn -> dn
    end
  end
end

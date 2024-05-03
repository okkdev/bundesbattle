defmodule BundesbattleWeb.TournamentLive do
  use BundesbattleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    Hello!
    <%= if @region.latitude and @region.longitude do %>
      <div
        id="map"
        data-lat={@tournament.location.latitude}
        data-lng={@tournament.location.longitude}
        phx-update="ignore"
        class="w-full h-80 my-16 rounded-md shadow"
      >
        <a href={@tournament.location.url}>
          <div>
            <span><b><%= @tournament.location.name %></b></span>
            <span><%= @tournament.location.address %></span>
            <span><%= @tournament.location.zip %> <%= @tournament.location.city %></span>
          </div>
        </a>
      </div>
    <% else %>
      <a href={@tournament.location.url}>
        <div>
          <span><b><%= @tournament.location.name %></b></span>
          <span><%= @tournament.location.address %></span>
          <span><%= @tournament.location.zip %> <%= @tournament.location.city %></span>
        </div>
      </a>
    <% end %>
    """
  end
end

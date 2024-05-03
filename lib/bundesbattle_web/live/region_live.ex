defmodule BundesbattleWeb.RegionLive do
  use BundesbattleWeb, :live_view

  alias Bundesbattle.Regions

  @impl true
  def render(assigns) do
    ~H"""
    Hello! <%= @region.name %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"region" => region_slug}, _url, socket) do
    region = Regions.get_region_by_slug!(region_slug)

    {:noreply, assign(socket, region: region)}
  end
end

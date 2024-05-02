defmodule BundesbattleWeb.RegionLive.Index do
  use BundesbattleWeb, :live_view

  alias Bundesbattle.Regions
  alias Bundesbattle.Regions.Region

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :regions, Regions.list_regions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Region")
    |> assign(:region, Regions.get_region!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Region")
    |> assign(:region, %Region{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Regions")
    |> assign(:region, nil)
  end

  @impl true
  def handle_info({BundesbattleWeb.RegionLive.FormComponent, {:saved, region}}, socket) do
    {:noreply, stream_insert(socket, :regions, region)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    region = Regions.get_region!(id)
    {:ok, _} = Regions.delete_region(region)

    {:noreply, stream_delete(socket, :regions, region)}
  end
end

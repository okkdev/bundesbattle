defmodule BundesbattleWeb.TournamentLive.FormComponent do
  use BundesbattleWeb, :live_component

  alias Bundesbattle.Events
  alias Bundesbattle.Repo

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tournament records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="tournament-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:datetime]} type="datetime-local" label="Datetime" />
        <.input field={@form[:bracket_link]} type="text" label="Bracket Link" />
        <.input
          field={@form[:game]}
          type="select"
          label="Game"
          prompt="Choose a value"
          options={Ecto.Enum.values(Bundesbattle.Events.Tournament, :game)}
        />
        <.input
          field={@form[:location_id]}
          type="select"
          label="Location"
          prompt="Choose a value"
          options={@locations |> Enum.map(&{&1.name, &1.id})}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tournament</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tournament: tournament} = assigns, socket) do
    changeset =
      tournament
      |> Repo.preload(:location)
      |> Events.change_tournament()

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"tournament" => tournament_params}, socket) do
    changeset =
      socket.assigns.tournament
      |> Events.change_tournament(tournament_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"tournament" => tournament_params}, socket) do
    save_tournament(socket, socket.assigns.action, tournament_params)
  end

  defp save_tournament(socket, :edit, tournament_params) do
    case Events.update_tournament(socket.assigns.tournament, tournament_params) do
      {:ok, tournament} ->
        tournament = Repo.preload(tournament, :location)
        notify_parent({:saved, tournament})

        {:noreply,
         socket
         |> put_flash(:info, "Tournament updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_tournament(socket, :new, tournament_params) do
    case Events.create_tournament(tournament_params) do
      {:ok, tournament} ->
        tournament = Repo.preload(tournament, :location)
        notify_parent({:saved, tournament})

        {:noreply,
         socket
         |> put_flash(:info, "Tournament created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

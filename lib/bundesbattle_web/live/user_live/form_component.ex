defmodule BundesbattleWeb.UserLive.FormComponent do
  use BundesbattleWeb, :live_component

  alias Bundesbattle.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage user records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:nickname]} type="text" label="Nickname" />
        <.input field={@form[:discord_user]} type="text" label="Discord Username" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          field={@form[:role]}
          type="select"
          label="Role"
          prompt="Choose a value"
          disabled={@current_user.role != :admin}
          options={
            Ecto.Enum.values(Bundesbattle.Accounts.User, :role)
            |> Enum.map(&{&1 |> Atom.to_string() |> String.capitalize(), &1})
          }
        />
        <.input
          field={@form[:canton]}
          type="select"
          label="Canton"
          prompt="Choose a value"
          options={
            Ecto.Enum.values(Bundesbattle.Accounts.User, :canton)
            |> Enum.map(&{&1 |> Atom.to_string() |> String.upcase(), &1})
          }
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save User</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    case Accounts.create_user(user_params, random_password: true) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
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

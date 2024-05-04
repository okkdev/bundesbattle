defmodule BundesbattleWeb.UserSettingsLive do
  use BundesbattleWeb, :live_view

  alias Bundesbattle.Accounts

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Account Settings
      <:subtitle>Manage your account settings</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form
          for={@settings_form}
          id="settings_form"
          phx-change="validate_settings"
          phx-submit="save_settings"
        >
          <.input field={@settings_form[:display_name]} type="text" label="Display Name" />
          <.input field={@settings_form[:username]} type="text" label="Username" />
          <%!-- <.input field={@settings_form[:image]} type="text" label="Image URL" /> --%>
          <.input
            field={@settings_form[:canton]}
            type="select"
            label="Canton"
            prompt="Choose a value"
            options={
              Ecto.Enum.values(Bundesbattle.Accounts.User, :canton)
              |> Enum.map(&{&1 |> Atom.to_string() |> String.upcase(), &1})
            }
          />

          <:actions>
            <.button phx-disable-with="Saving...">Save</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@email_form}
          id="email_form"
          phx-submit="update_email"
          phx-change="validate_email"
        >
          <.input field={@email_form[:email]} type="email" label="Email" required />
          <:actions>
            <.button phx-disable-with="Changing...">Change Email</.button>
          </:actions>
        </.simple_form>
      </div>
      <%!-- <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/login?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <input
            name={@password_form[:email].name}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm new password"
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Password</.button>
          </:actions>
        </.simple_form>
      </div> --%>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/user/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)
    settings_changeset = Accounts.change_user(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:settings_form, to_form(settings_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_settings", params, socket) do
    %{"user" => user_params} = params

    settings_form =
      socket.assigns.current_user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, settings_form: settings_form)}
  end

  def handle_event("save_settings", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user(user, user_params) do
      {:ok, _} ->
        {:noreply, socket |> put_flash(:info, "Settings saved")}

      {:error, _} ->
        {:noreply, socket |> put_flash(:error, "Error saving settings")}
    end
  end

  def handle_event("validate_email", params, socket) do
    %{"user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form)}
  end

  def handle_event("update_email", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_email_noconfirm(user, user_params["email"]) do
      {:ok, _} ->
        {:noreply, socket |> put_flash(:info, "Updated Email.")}

      {:error, _} ->
        {:noreply, socket |> put_flash(:error, "Error updating Email.")}
    end

    # case Accounts.apply_user_email(user, user_params) do
    #   {:ok, applied_user} ->
    #     Accounts.deliver_user_update_email_instructions(
    #       applied_user,
    #       user.email,
    #       &url(~p"/user/settings/confirm_email/#{&1}")
    #     )
    #
    #     info = "A link to confirm your email change has been sent to the new address."
    #     {:noreply, socket |> put_flash(:info, info)}
    #
    #   {:error, changeset} ->
    #     {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    # end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end

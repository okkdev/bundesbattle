defmodule BundesbattleWeb.UserLoginLive do
  use BundesbattleWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <p>
        Logging in will allow you to create/customize your profile.
        As well as add you to the player database, which makes the organizers' jobs easier. :)
      </p>
      <div class="flex justify-center mt-12">
        <.link
          patch={~p"/auth/discord"}
          class="inline-flex items-center gap-x-2 rounded-md bg-[#5865F2] px-3.5 py-2.5 text-md font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          <svg
            class="h-5 w-5 flex-none text-white"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 127.14 96.36"
            fill="currentColor"
          >
            <g id="图层_2" data-name="图层 2">
              <g id="Discord_Logos" data-name="Discord Logos">
                <g id="Discord_Logo" data-name="Discord Logo">
                  <path d="M107.7,8.07A105.15,105.15,0,0,0,81.47,0a72.06,72.06,0,0,0-3.36,6.83A97.68,97.68,0,0,0,49,6.83,72.37,72.37,0,0,0,45.64,0,105.89,105.89,0,0,0,19.39,8.09C2.79,32.65-1.71,56.6.54,80.21h0A105.73,105.73,0,0,0,32.71,96.36,77.7,77.7,0,0,0,39.6,85.25a68.42,68.42,0,0,1-10.85-5.18c.91-.66,1.8-1.34,2.66-2a75.57,75.57,0,0,0,64.32,0c.87.71,1.76,1.39,2.66,2a68.68,68.68,0,0,1-10.87,5.19,77,77,0,0,0,6.89,11.1A105.25,105.25,0,0,0,126.6,80.22h0C129.24,52.84,122.09,29.11,107.7,8.07ZM42.45,65.69C36.18,65.69,31,60,31,53s5-12.74,11.43-12.74S54,46,53.89,53,48.84,65.69,42.45,65.69Zm42.24,0C78.41,65.69,73.25,60,73.25,53s5-12.74,11.44-12.74S96.23,46,96.12,53,91.08,65.69,84.69,65.69Z" />
                </g>
              </g>
            </g>
          </svg>
          Login
        </.link>
      </div>
      <%!--
      <.simple_form for={@form} id="login_form" action={~p"/login"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/user/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
      --%>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    # email = Phoenix.Flash.get(socket.assigns.flash, :email)
    # form = to_form(%{"email" => email}, as: "user")
    # {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
    {:ok, socket}
  end
end

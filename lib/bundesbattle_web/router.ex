defmodule BundesbattleWeb.Router do
  use BundesbattleWeb, :router

  import BundesbattleWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BundesbattleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BundesbattleWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", BundesbattleWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bundesbattle, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BundesbattleWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/auth", BundesbattleWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", BundesbattleWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{BundesbattleWeb.UserAuth, :ensure_authenticated}] do
      live "/user/settings", UserSettingsLive, :edit
      live "/user/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", BundesbattleWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{BundesbattleWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      # live "/register", UserRegistrationLive, :new
      live "/login", UserLoginLive, :new
      live "/user/reset_password", UserForgotPasswordLive, :new
      live "/user/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/login", UserSessionController, :create
  end

  scope "/", BundesbattleWeb do
    pipe_through [:browser]

    delete "/logout", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{BundesbattleWeb.UserAuth, :mount_current_user}] do
      live "/user/confirm/:token", UserConfirmationLive, :edit
      live "/user/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  scope "/manage", BundesbattleWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_organizer,
      on_mount: [{BundesbattleWeb.UserAuth, :ensure_organizer}] do
      live "/tournaments", TournamentLive.Index, :index
      live "/tournaments/new", TournamentLive.Index, :new
      live "/tournaments/:id/edit", TournamentLive.Index, :edit

      live "/tournaments/:id", TournamentLive.Show, :show
      live "/tournaments/:id/show/edit", TournamentLive.Show, :edit
    end
  end
end

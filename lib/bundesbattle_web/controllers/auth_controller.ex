defmodule BundesbattleWeb.AuthController do
  use BundesbattleWeb, :controller

  alias Bundesbattle.Accounts
  alias BundesbattleWeb.UserAuth

  plug Ueberauth

  @rand_pass_length 32

  def callback(%{assigns: %{ueberauth_auth: %{info: user_info}}} = conn, _params) do
    user_params = %{
      email: user_info.email,
      nickname: user_info.nickname,
      discord_user: user_info.nickname,
      image: user_info.image,
      password: random_password()
    }

    case Accounts.fetch_or_create_user(user_params) do
      {:ok, user} ->
        UserAuth.log_in_user(conn, user, %{"remember_me" => "true"})

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed")
    |> redirect(to: "/")
  end

  defp random_password do
    :crypto.strong_rand_bytes(@rand_pass_length) |> Base.encode64()
  end
end

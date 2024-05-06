defmodule BundesbattleWeb.Components do
  use Phoenix.Component

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
end

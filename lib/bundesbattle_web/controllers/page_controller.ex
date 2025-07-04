defmodule BundesbattleWeb.PageController do
  use BundesbattleWeb, :controller

  alias Bundesbattle.Events

  def home(conn, _params) do
    upcoming_tournaments =
      Events.upcoming_tournaments()
      |> Enum.sort(&(NaiveDateTime.compare(&1.datetime, &2.datetime) != :gt))

    upcoming_tournament_zurich =
      upcoming_tournaments
      |> Enum.find(&(&1.location.region.slug == "zurich"))

    upcoming_tournament_basel =
      upcoming_tournaments
      |> Enum.find(&(&1.location.region.slug == "basel"))

    # upcoming_tournament_lausanne =
    #   upcoming_tournaments
    #   |> Enum.find(&(&1.location.region.slug == "lausanne"))

    upcoming_tournament_bern =
      upcoming_tournaments
      |> Enum.find(&(&1.location.region.slug == "bern"))

    render(conn, :home,
      layout: false,
      upcoming_tournaments: upcoming_tournaments,
      upcoming_tournament_zurich: upcoming_tournament_zurich,
      upcoming_tournament_basel: upcoming_tournament_basel,
      upcoming_tournament_bern: upcoming_tournament_bern
    )
  end
end

defmodule Bundesbattle.Leaderboard do
  alias Bundesbattle.Events.TournamentPlayer

  def create(tournaments, game) do
    tournaments
    |> Enum.filter(&(&1.game == game))
    |> Enum.flat_map(fn tournament ->
      Enum.map(tournament.players, fn player ->
        %{points: assign_points(player), player: player}
      end)
    end)
    |> Enum.reduce(%{}, fn p, acc ->
      case acc[p.player.user.id] do
        %{player: player, points: points} ->
          Map.put(acc, player.id, %{player: player, points: [p.points | points]})

        nil ->
          Map.put(acc, p.player.user.id, %{player: p.player.user, points: [p.points]})
      end
    end)
    |> Enum.map(fn {_, %{player: player, points: points}} ->
      %{
        player: player,
        points:
          points
          |> Enum.sort(&(&1 >= &2))
          |> Enum.take(4)
          |> Enum.sum()
      }
    end)
    |> Enum.sort(fn p1, p2 -> p1.points >= p2.points end)
    |> Enum.with_index(fn p, index -> %{place: index + 1, player: p.player, points: p.points} end)
  end

  def assign_points(%TournamentPlayer{} = player) do
    case player.placement do
      1 -> 8
      2 -> 6
      3 -> 4
      4 -> 3
      5 -> 2
      7 -> 1
      _ -> 0
    end
  end
end

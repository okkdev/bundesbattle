defmodule Bundesbattle.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bundesbattle.Events` context.
  """

  @doc """
  Generate a tournament.
  """
  def tournament_fixture(attrs \\ %{}) do
    {:ok, tournament} =
      attrs
      |> Enum.into(%{
        datetime: ~N[2024-04-27 17:55:00],
        game: :tekken,
        name: "some name",
        region: :basel
      })
      |> Bundesbattle.Events.create_tournament()

    tournament
  end
end

defmodule Bundesbattle.EventsTest do
  use Bundesbattle.DataCase

  alias Bundesbattle.Events

  describe "tournaments" do
    alias Bundesbattle.Events.Tournament

    import Bundesbattle.EventsFixtures

    @invalid_attrs %{name: nil, datetime: nil, game: nil, region: nil}

    test "list_tournaments/0 returns all tournaments" do
      tournament = tournament_fixture()
      assert Events.list_tournaments() == [tournament]
    end

    test "get_tournament!/1 returns the tournament with given id" do
      tournament = tournament_fixture()
      assert Events.get_tournament!(tournament.id) == tournament
    end

    test "create_tournament/1 with valid data creates a tournament" do
      valid_attrs = %{name: "some name", datetime: ~N[2024-04-27 17:55:00], game: :tekken, region: :basel}

      assert {:ok, %Tournament{} = tournament} = Events.create_tournament(valid_attrs)
      assert tournament.name == "some name"
      assert tournament.datetime == ~N[2024-04-27 17:55:00]
      assert tournament.game == :tekken
      assert tournament.region == :basel
    end

    test "create_tournament/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_tournament(@invalid_attrs)
    end

    test "update_tournament/2 with valid data updates the tournament" do
      tournament = tournament_fixture()
      update_attrs = %{name: "some updated name", datetime: ~N[2024-04-28 17:55:00], game: :streetfighter, region: :lausanne}

      assert {:ok, %Tournament{} = tournament} = Events.update_tournament(tournament, update_attrs)
      assert tournament.name == "some updated name"
      assert tournament.datetime == ~N[2024-04-28 17:55:00]
      assert tournament.game == :streetfighter
      assert tournament.region == :lausanne
    end

    test "update_tournament/2 with invalid data returns error changeset" do
      tournament = tournament_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_tournament(tournament, @invalid_attrs)
      assert tournament == Events.get_tournament!(tournament.id)
    end

    test "delete_tournament/1 deletes the tournament" do
      tournament = tournament_fixture()
      assert {:ok, %Tournament{}} = Events.delete_tournament(tournament)
      assert_raise Ecto.NoResultsError, fn -> Events.get_tournament!(tournament.id) end
    end

    test "change_tournament/1 returns a tournament changeset" do
      tournament = tournament_fixture()
      assert %Ecto.Changeset{} = Events.change_tournament(tournament)
    end
  end
end

defmodule Bundesbattle.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Bundesbattle.Repo

  alias Bundesbattle.Events.Tournament
  alias Bundesbattle.Events.TournamentPlayer

  @doc """
  Returns the list of tournaments.

  ## Examples

      iex> list_tournaments()
      [%Tournament{}, ...]

  """
  def list_tournaments do
    Repo.all(Tournament)
    |> Repo.preload(:location)
  end

  @doc """
  Gets a single tournament.

  Raises `Ecto.NoResultsError` if the Tournament does not exist.

  ## Examples

      iex> get_tournament!(123)
      %Tournament{}

      iex> get_tournament!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament!(id) do
    Repo.get!(Tournament, id)
    |> Repo.preload(location: :region)
  end

  @doc """
  Creates a tournament.

  ## Examples

      iex> create_tournament(%{field: value})
      {:ok, %Tournament{}}

      iex> create_tournament(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament(attrs \\ %{}) do
    %Tournament{}
    |> Tournament.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament.

  ## Examples

      iex> update_tournament(tournament, %{field: new_value})
      {:ok, %Tournament{}}

      iex> update_tournament(tournament, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament(%Tournament{} = tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tournament.

  ## Examples

      iex> delete_tournament(tournament)
      {:ok, %Tournament{}}

      iex> delete_tournament(tournament)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament(%Tournament{} = tournament) do
    Repo.delete(tournament)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament changes.

  ## Examples

      iex> change_tournament(tournament)
      %Ecto.Changeset{data: %Tournament{}}

  """
  def change_tournament(%Tournament{} = tournament, attrs \\ %{}) do
    Tournament.changeset(tournament, attrs)
  end

  def upcoming_tournaments() do
    now = DateTime.utc_now()

    query =
      from t in Tournament,
        where: t.datetime > ^now

    Repo.all(query)
    |> Repo.preload(location: :region)
  end

  def get_tournament_player!(id) do
    Repo.get!(TournamentPlayer, id)
    |> Repo.preload(:user)
  end

  def change_tournament_player(%TournamentPlayer{} = tournament_player, attrs \\ %{}) do
    TournamentPlayer.changeset(tournament_player, attrs)
  end

  def create_tournament_player(attrs \\ %{}) do
    %TournamentPlayer{}
    |> TournamentPlayer.changeset(attrs)
    |> Repo.insert()
  end

  def delete_tournament_player(%TournamentPlayer{} = tournament_player) do
    Repo.delete(tournament_player)
  end

  def preload_tournament_player(%TournamentPlayer{} = tournament_player) do
    Repo.preload(tournament_player, :user)
  end

  def list_tournament_players_for_tournament(tournament_id) do
    Repo.all(TournamentPlayer, tournament_id: tournament_id)
    |> Repo.preload(:user)
  end
end

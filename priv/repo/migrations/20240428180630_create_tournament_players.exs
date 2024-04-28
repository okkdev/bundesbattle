defmodule Bundesbattle.Repo.Migrations.CreateTournamentPlayers do
  use Ecto.Migration

  def change do
    create table(:tournament_players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :placement, :integer
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :binary_id)
      add :player_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:tournament_players, [:tournament_id])
    create index(:tournament_players, [:player_id])
  end
end

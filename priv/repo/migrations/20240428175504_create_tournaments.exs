defmodule Bundesbattle.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :bracket_link, :string
      add :datetime, :naive_datetime, null: false
      add :game, :string, null: false
      add :bundesbattle_season, :integer, null: false
      add :location_id, references(:locations, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end
  end
end

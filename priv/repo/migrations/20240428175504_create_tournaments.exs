defmodule Bundesbattle.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :bracket_link, :string
      add :datetime, :naive_datetime
      add :game, :string
      add :location_id, references(:locations, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end
  end
end

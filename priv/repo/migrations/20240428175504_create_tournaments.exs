defmodule Bundesbattle.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :datetime, :naive_datetime
      add :game, :string
      add :region, :string

      timestamps(type: :utc_datetime)
    end
  end
end

defmodule Bundesbattle.Repo.Migrations.CreateRegions do
  use Ecto.Migration

  def change do
    create table(:regions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :qualifier_type, :string

      timestamps(type: :utc_datetime)
    end
  end
end

defmodule Bundesbattle.Repo.Migrations.CreateRegions do
  use Ecto.Migration

  def change do
    create table(:regions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :slug, :string
      add :qualifier_type, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:regions, [:slug])
  end
end

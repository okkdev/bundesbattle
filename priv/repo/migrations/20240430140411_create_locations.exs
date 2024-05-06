defmodule Bundesbattle.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :address, :string
      add :zip, :integer
      add :city, :string
      add :url, :string
      add :latitude, :float
      add :longitude, :float
      add :region_id, references(:regions, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end
  end
end

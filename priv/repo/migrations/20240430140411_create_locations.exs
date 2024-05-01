defmodule Bundesbattle.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :region, :string
      add :name, :string
      add :address, :string
      add :zip, :integer
      add :city, :string
      add :location_url, :string
      add :latitude, :float
      add :longitude, :float

      timestamps(type: :utc_datetime)
    end
  end
end

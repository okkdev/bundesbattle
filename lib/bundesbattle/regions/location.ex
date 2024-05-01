defmodule Bundesbattle.Regions.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Uniq.UUID, version: 7, autogenerate: true}
  @foreign_key_type Uniq.UUID
  schema "locations" do
    field :region, :string
    field :name, :string
    field :address, :string
    field :zip, :integer
    field :city, :string
    field :location_url, :string
    field :latitude, :float
    field :longitude, :float
    has_many :tournaments, Bundesbattle.Events.Tournament

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:region, :name, :address, :zip, :city, :location_url, :latitude, :longitude])
    |> validate_required([
      :region
    ])
    |> Bundesbattle.Utils.validate_url(:location_url)
  end
end

defmodule Bundesbattle.Regions.Region do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Uniq.UUID, version: 7, autogenerate: true}
  @foreign_key_type Uniq.UUID
  schema "regions" do
    field :name, :string
    field :qualifier_type, Ecto.Enum, values: [:monthly, :direct, :final]
    has_many :locations, Bundesbattle.Regions.Location

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(region, attrs) do
    region
    |> cast(attrs, [:name, :qualifier_type])
    |> validate_required([:name, :qualifier_type])
  end
end

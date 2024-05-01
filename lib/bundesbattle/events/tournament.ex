defmodule Bundesbattle.Events.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Uniq.UUID, version: 7, autogenerate: true}
  @foreign_key_type Uniq.UUID
  schema "tournaments" do
    field :name, :string
    field :bracket_link, :string
    field :datetime, :naive_datetime
    field :game, Ecto.Enum, values: [:tekken, :streetfighter]
    belongs_to :location, Bundesbattle.Regions.Location

    many_to_many :players, Bundesbattle.Accounts.User,
      join_through: Bundesbattle.Events.TournamentPlayer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :bracket_link, :datetime, :game, :location_id])
    |> validate_required([:name, :datetime, :game, :location_id])
    |> Bundesbattle.Utils.validate_url(:bracket_link)
  end
end

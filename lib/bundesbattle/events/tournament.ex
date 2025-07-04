defmodule Bundesbattle.Events.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  # TODO: Add organizer
  @primary_key {:id, Uniq.UUID, version: 7, autogenerate: true}
  @foreign_key_type Uniq.UUID
  schema "tournaments" do
    field :name, :string
    field :bracket_link, :string
    field :datetime, :naive_datetime
    field :bundesbattle_season, :integer, default: 3
    field :description, :string
    field :game, Ecto.Enum, values: [:tekken, :streetfighter, :guiltygear]
    belongs_to :location, Bundesbattle.Regions.Location
    has_many :players, Bundesbattle.Events.TournamentPlayer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [
      :name,
      :bracket_link,
      :datetime,
      :description,
      :game,
      :bundesbattle_season,
      :location_id
    ])
    |> validate_required([:name, :datetime, :game, :bundesbattle_season, :location_id])
    |> Bundesbattle.Utils.validate_url(:bracket_link)
  end
end

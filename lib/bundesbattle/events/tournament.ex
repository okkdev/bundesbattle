defmodule Bundesbattle.Events.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tournaments" do
    field :name, :string
    field :datetime, :naive_datetime
    field :game, Ecto.Enum, values: [:tekken, :streetfighter]
    field :region, Ecto.Enum, values: [:basel, :lausanne, :zurich]

    many_to_many :players, Bundesbattle.Accounts.User,
      join_through: Bundesbattle.Events.TournamentPlayer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :datetime, :game, :region])
    |> validate_required([:name, :datetime, :game, :region])
  end
end

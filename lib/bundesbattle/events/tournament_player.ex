defmodule Bundesbattle.Events.TournamentPlayer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tournament_players" do
    field :placement, :integer
    belongs_to :tournament, Bundesbattle.Events.Tournament
    belongs_to :player, Bundesbattle.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tournament_player, attrs) do
    tournament_player
    |> cast(attrs, [:placement])
    |> validate_required([:placement])
  end
end
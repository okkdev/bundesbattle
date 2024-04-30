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
    field :region, Ecto.Enum, values: [:basel, :lausanne, :zurich, :direct_qualifier]

    many_to_many :players, Bundesbattle.Accounts.User,
      join_through: Bundesbattle.Events.TournamentPlayer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :bracket_link, :datetime, :game, :region])
    |> validate_required([:name, :datetime, :game, :region])
    |> validate_url(:bracket_link)
  end

  defp validate_url(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: nil} ->
          [{field, Keyword.get(opts, :message, "missing a scheme (e.g. https)")}]

        %URI{host: nil} ->
          [{field, Keyword.get(opts, :message, "missing a host")}]

        %URI{host: ""} ->
          [{field, Keyword.get(opts, :message, "missing a host")}]

        _ ->
          []
      end
    end)
  end
end

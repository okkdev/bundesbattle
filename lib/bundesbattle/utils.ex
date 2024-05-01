defmodule Bundesbattle.Utils do
  def validate_url(changeset, field, opts \\ []) do
    import Ecto.Changeset

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

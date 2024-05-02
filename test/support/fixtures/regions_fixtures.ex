defmodule Bundesbattle.RegionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bundesbattle.Regions` context.
  """

  @doc """
  Generate a location.
  """
  def location_fixture(attrs \\ %{}) do
    {:ok, location} =
      attrs
      |> Enum.into(%{
        address: "some address",
        city: "some city",
        latitude: 120.5,
        location_url: "some location_url",
        longitude: 120.5,
        name: "some name",
        region: "some region",
        zip: 42
      })
      |> Bundesbattle.Regions.create_location()

    location
  end

  @doc """
  Generate a region.
  """
  def region_fixture(attrs \\ %{}) do
    {:ok, region} =
      attrs
      |> Enum.into(%{
        name: "some name",
        qualifier_type: :monthly
      })
      |> Bundesbattle.Regions.create_region()

    region
  end
end

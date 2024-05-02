defmodule Bundesbattle.RegionsTest do
  use Bundesbattle.DataCase

  alias Bundesbattle.Regions

  describe "locations" do
    alias Bundesbattle.Regions.Location

    import Bundesbattle.RegionsFixtures

    @invalid_attrs %{name: nil, zip: nil, address: nil, region: nil, city: nil, location_url: nil, latitude: nil, longitude: nil}

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert Regions.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert Regions.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      valid_attrs = %{name: "some name", zip: 42, address: "some address", region: "some region", city: "some city", location_url: "some location_url", latitude: 120.5, longitude: 120.5}

      assert {:ok, %Location{} = location} = Regions.create_location(valid_attrs)
      assert location.name == "some name"
      assert location.zip == 42
      assert location.address == "some address"
      assert location.region == "some region"
      assert location.city == "some city"
      assert location.location_url == "some location_url"
      assert location.latitude == 120.5
      assert location.longitude == 120.5
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Regions.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      update_attrs = %{name: "some updated name", zip: 43, address: "some updated address", region: "some updated region", city: "some updated city", location_url: "some updated location_url", latitude: 456.7, longitude: 456.7}

      assert {:ok, %Location{} = location} = Regions.update_location(location, update_attrs)
      assert location.name == "some updated name"
      assert location.zip == 43
      assert location.address == "some updated address"
      assert location.region == "some updated region"
      assert location.city == "some updated city"
      assert location.location_url == "some updated location_url"
      assert location.latitude == 456.7
      assert location.longitude == 456.7
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Regions.update_location(location, @invalid_attrs)
      assert location == Regions.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = Regions.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Regions.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = Regions.change_location(location)
    end
  end

  describe "regions" do
    alias Bundesbattle.Regions.Region

    import Bundesbattle.RegionsFixtures

    @invalid_attrs %{name: nil, qualifier_type: nil}

    test "list_regions/0 returns all regions" do
      region = region_fixture()
      assert Regions.list_regions() == [region]
    end

    test "get_region!/1 returns the region with given id" do
      region = region_fixture()
      assert Regions.get_region!(region.id) == region
    end

    test "create_region/1 with valid data creates a region" do
      valid_attrs = %{name: "some name", qualifier_type: :monthly}

      assert {:ok, %Region{} = region} = Regions.create_region(valid_attrs)
      assert region.name == "some name"
      assert region.qualifier_type == :monthly
    end

    test "create_region/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Regions.create_region(@invalid_attrs)
    end

    test "update_region/2 with valid data updates the region" do
      region = region_fixture()
      update_attrs = %{name: "some updated name", qualifier_type: :direct}

      assert {:ok, %Region{} = region} = Regions.update_region(region, update_attrs)
      assert region.name == "some updated name"
      assert region.qualifier_type == :direct
    end

    test "update_region/2 with invalid data returns error changeset" do
      region = region_fixture()
      assert {:error, %Ecto.Changeset{}} = Regions.update_region(region, @invalid_attrs)
      assert region == Regions.get_region!(region.id)
    end

    test "delete_region/1 deletes the region" do
      region = region_fixture()
      assert {:ok, %Region{}} = Regions.delete_region(region)
      assert_raise Ecto.NoResultsError, fn -> Regions.get_region!(region.id) end
    end

    test "change_region/1 returns a region changeset" do
      region = region_fixture()
      assert %Ecto.Changeset{} = Regions.change_region(region)
    end
  end
end

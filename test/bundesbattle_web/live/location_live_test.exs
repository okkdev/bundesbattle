defmodule BundesbattleWeb.Manage.LocationLiveTest do
  use BundesbattleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bundesbattle.RegionsFixtures

  @create_attrs %{name: "some name", zip: 42, address: "some address", region: "some region", city: "some city", url: "some url", latitude: 120.5, longitude: 120.5}
  @update_attrs %{name: "some updated name", zip: 43, address: "some updated address", region: "some updated region", city: "some updated city", url: "some updated url", latitude: 456.7, longitude: 456.7}
  @invalid_attrs %{name: nil, zip: nil, address: nil, region: nil, city: nil, url: nil, latitude: nil, longitude: nil}

  defp create_location(_) do
    location = location_fixture()
    %{location: location}
  end

  describe "Index" do
    setup [:create_location]

    test "lists all locations", %{conn: conn, location: location} do
      {:ok, _index_live, html} = live(conn, ~p"/manage/locations")

      assert html =~ "Listing Locations"
      assert html =~ location.name
    end

    test "saves new location", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/manage/locations")

      assert index_live |> element("a", "New Location") |> render_click() =~
               "New Location"

      assert_patch(index_live, ~p"/manage/locations/new")

      assert index_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#location-form", location: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/manage/locations")

      html = render(index_live)
      assert html =~ "Location created successfully"
      assert html =~ "some name"
    end

    test "updates location in listing", %{conn: conn, location: location} do
      {:ok, index_live, _html} = live(conn, ~p"/manage/locations")

      assert index_live |> element("#locations-#{location.id} a", "Edit") |> render_click() =~
               "Edit Location"

      assert_patch(index_live, ~p"/manage/locations/#{location}/edit")

      assert index_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#location-form", location: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/manage/locations")

      html = render(index_live)
      assert html =~ "Location updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes location in listing", %{conn: conn, location: location} do
      {:ok, index_live, _html} = live(conn, ~p"/manage/locations")

      assert index_live |> element("#locations-#{location.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#locations-#{location.id}")
    end
  end

  describe "Show" do
    setup [:create_location]

    test "displays location", %{conn: conn, location: location} do
      {:ok, _show_live, html} = live(conn, ~p"/manage/locations/#{location}")

      assert html =~ "Show Location"
      assert html =~ location.name
    end

    test "updates location within modal", %{conn: conn, location: location} do
      {:ok, show_live, _html} = live(conn, ~p"/manage/locations/#{location}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Location"

      assert_patch(show_live, ~p"/manage/locations/#{location}/show/edit")

      assert show_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#location-form", location: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/manage/locations/#{location}")

      html = render(show_live)
      assert html =~ "Location updated successfully"
      assert html =~ "some updated name"
    end
  end
end

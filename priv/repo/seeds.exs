# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bundesbattle.Repo.insert!(%Bundesbattle.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, okk} =
  Bundesbattle.Accounts.create_user(
    %{
      "display_name" => nil,
      "username" => "okk",
      "canton" => nil,
      "discord_id" => "116146991540600840",
      "email" => "dev@stehlik.me",
      "role" => :admin
    },
    random_password: true
  )

{:ok, basel} =
  Bundesbattle.Regions.create_region(%{
    name: "Basel",
    slug: "basel",
    qualifier_type: :monthly
  })

Bundesbattle.Regions.create_region(%{
  name: "Zürich",
  slug: "zurich",
  qualifier_type: :monthly
})

Bundesbattle.Regions.create_region(%{
  name: "Lausanne",
  slug: "lausanne",
  qualifier_type: :monthly
})

{:ok, manabar} =
  Bundesbattle.Regions.create_location(%{
    name: "ManaBar",
    address: "Güterstrasse 99",
    zip: 4053,
    city: "Basel",
    url: "https://manabar.ch/",
    latitude: 47.5461561,
    longitude: 7.5861434,
    region_id: basel.id
  })

{:ok, t1} =
  Bundesbattle.Events.create_tournament(%{
    name: "Monthly Mash #Test",
    bracket_link: "https://fgcbasel.ch/",
    datetime: ~N[2024-07-12 00:01:00],
    bundesbattle_season: 2,
    game: :streetfighter,
    location_id: manabar.id
  })

{:ok, t2} =
  Bundesbattle.Events.create_tournament(%{
    name: "Monthly Mash #Test2",
    bracket_link: "https://fgcbasel.ch/",
    datetime: ~N[2024-09-13 00:02:00],
    bundesbattle_season: 2,
    game: :tekken,
    location_id: manabar.id
  })

Bundesbattle.Events.create_tournament_player(%{
  placement: 2,
  user_id: okk.id,
  tournament_id: t1.id
})

Bundesbattle.Events.create_tournament_player(%{
  placement: 3,
  user_id: okk.id,
  tournament_id: t2.id
})

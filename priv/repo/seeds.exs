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

Bundesbattle.Accounts.create_user(
  %{
    name: nil,
    nickname: "okk",
    canton: nil,
    discord_user: "okk",
    email: "dev@stehlik.me",
    role: :admin
  },
  random_password: true
)

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

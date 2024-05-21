defmodule BundesbattleWeb.SEO do
  defstruct title: "BundesBattle Season 2",
            description: """
            We're back with another season of heated competition to find the best Street Fighter 6 and Tekken 8 player in Switzerland!
            Prove your consistency by gathering points, or make an explosive entrance by winning one of our direct qualifiers!
            """,
            url: "/",
            image: "/images/bundesbattle-social.webp"

  def new(attrs \\ %{}) do
    struct(__MODULE__, attrs)
  end

  def build(%__MODULE__{} = seo) do
    %{
      "title" => seo.title,
      "og:title" => seo.title,
      "twitter:title" => seo.title,
      "description" => seo.description,
      "og:description" => seo.description,
      "twitter:description" => seo.description,
      "og:type" => "website",
      "og:url" => BundesbattleWeb.Endpoint.url() <> seo.url,
      "twitter:url" => BundesbattleWeb.Endpoint.url() <> seo.url,
      "twitter:card" => "summary_large_image",
      "og:image" => BundesbattleWeb.Endpoint.url() <> seo.image,
      "twitter:image" => BundesbattleWeb.Endpoint.url() <> seo.image
    }
  end
end

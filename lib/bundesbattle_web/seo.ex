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
      "description" => seo.description,
      "og:description" => seo.description,
      "og:image" => BundesbattleWeb.Endpoint.url() <> seo.image,
      "og:site_name" => "BundesBattle",
      "og:title" => seo.title,
      "og:type" => "website",
      "og:url" => BundesbattleWeb.Endpoint.url() <> seo.url,
      "twitter:card" => "summary_large_image",
      "twitter:description" => seo.description,
      "twitter:image" => BundesbattleWeb.Endpoint.url() <> seo.image,
      "twitter:title" => seo.title,
      "twitter:url" => BundesbattleWeb.Endpoint.url() <> seo.url
    }
  end
end

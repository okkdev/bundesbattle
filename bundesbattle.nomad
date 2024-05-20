job "bundesbattle" {
  datacenters = ["dc1"]
  type = "service"

  group "bundesbattle" {
    count = 1

    network {
       port "http" {
         to = 4000
       }
    }

    service {
      name = "bundesbattle"
      port = "http"
      provider = "nomad"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.bundesbattle.rule=Host(`bundesbattle.ch`)",
        "traefik.http.routers.bundesbattle.tls=true",
        "traefik.http.routers.bundesbattle.tls.certresolver=letsencrypt"
      ]
    }

    volume "bundesbattle_db" {
      type = "host"
      source = "bundesbattle"
      read_only = false
    }

    task "bundesbattle" {
      driver = "docker"

      config {
        image = "ghcr.io/okkdev/bundesbattle:latest"
        ports = ["http"]
      }

      env {
        // Generate a new one with `mix phx.gen.secret`
        SECRET_KEY_BASE = "EnAKKOeidZIhIhPnWrr2V/HfuT4JAtw3M9utLNUc59R52zjZaYVTpsrz2zAsnCT7"
        PHX_HOST = "bundesbattle.ch"
        DATABASE_PATH = "/db/bundesbattle.db"
      }

      volume_mount {
        volume = "bundesbattle_db"
        destination = "/db"
      }

      resources {
        cpu = 1000
        memory = 1000
      }
    }
  }
}

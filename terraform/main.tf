terraform {
  cloud {
    organization = "geekzone"
    hostname = "app.terraform.io"

    workspaces {
      name = "estate-config"
    }
  }

  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "0.50.0"
    }

    github = {
      source = "integrations/github"
      version = "5.42.0"
    }

  }
}

provider "tfe" {
}


provider "github" {
}

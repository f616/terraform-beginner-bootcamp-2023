terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  cloud {
    organization = "f616Org"
    workspaces {
      name = "terra-house-1"
    }
  }  
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terrarowns_access_token
}

module "home_01_hosting"{
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.home01.public_path
  content_version = var.home01.content_version
}

resource "terratowns_home" "home_01" {
  name = "Arkanoid: One of most addictive games in the 80's!"
  description = <<DESCRIPTION
  This is about arkanoid. A brief history of the game.
  The ports and the current evolution of the game.
  DESCRIPTION
  domain_name = module.home_01_hosting.domain_name
  town = "missingo"
  content_version = var.home01.content_version
}

module "home_02_hosting"{
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.home02.public_path
  content_version = var.home02.content_version
}

resource "terratowns_home" "home_02" {
  name = "Recipe for Chocolate Salami"
  description = <<DESCRIPTION
  This chocolate salami is the perfect crunchy treat to snack on alongside coffee.
  These ultra chocolatey cookie slices are filled with toasty hazelnuts and vanilla
  wafer cookies. They're incredibly delicious and simple to make and doesn't require any oven.
  DESCRIPTION
  domain_name = module.home_02_hosting.domain_name
  town = "missingo"
  content_version = var.home02.content_version
}
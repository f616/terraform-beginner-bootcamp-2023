terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  # cloud {
  #   organization = "f616Org"
  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }  
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terrarowns_access_token
}

module "terrahouse_aws"{
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}

resource "terratowns_home" "home_arkanoid" {
  name = "Arkanoid: One of most addictive games in the 80's!"
  description = <<DESCRIPTION
  This is about arkanoid. A brief history of the game.
  The ports and the current evolution of the game.
  DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  # domain_name = "c93msdj.cloudfront.net"
  town = "missingo"
  content_version = 1
}
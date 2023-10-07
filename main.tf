terraform {
    # cloud {
    #     organization = "sauliusstasiukaitis"

    #     workspaces {
    #         name = "terra-house-1"
    #     }
    # }

    required_providers {
        terratowns = {
            source = "local.providers/local/terratowns"
            version = "1.0.0"
        }
    }
}

provider "terratowns" {
    endpoint = var.terratowns_endpoint
    user_uuid = var.teacherseat_user_uuid # "294fc01b-096b-4c61-bc0d-5278e8746f68" 
    token = var.terratowns_access_token # "38f457f1-0d2a-42b4-b412-3e56b4e77af8"
}

resource "terratowns_home" "home" {
    name = "How to gamble"
    description = "Just a playground for Terraform"
    domain_name = module.terrahouse_aws.cloudfront_url
    # domain_name = "d22fvnxw4kno2n.cloudfront.net"
    town = "missingo"
    content_version = 1
}

module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.teacherseat_user_uuid
    index_html_file_path = var.index_html_file_path
    error_html_file_path = var.error_html_file_path
    content_version = var.content_version
    assets_path = var.assets_path
}

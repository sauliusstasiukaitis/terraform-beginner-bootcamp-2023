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
    endpoint = "http://localhost:4567/api"
    user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
    token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

resource "terratowns_home" "home" {
    name = "How to gamble"
    description = "Just a playground for Terraform"
    # domain_name = module.terrahouse_aws.cloudfront_ur
    domain_name = "d22fvnxw4kno2n.cloudfront.net"
    town = "gamers-grotto"
    content_version = 1
}

# module "terrahouse_aws" {
#     source = "./modules/terrahouse_aws"
#     user_uuid = var.user_uuid
#     bucket_name = var.bucket_name
#     index_html_file_path = var.index_html_file_path
#     error_html_file_path = var.error_html_file_path
#     content_version = var.content_version
#     assets_path = var.assets_path
# }

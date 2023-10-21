terraform {
    cloud {
        organization = "sauliusstasiukaitis"

        workspaces {
            name = "terra-house-1"
        }
    }

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

module "terratowns_gambling" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.teacherseat_user_uuid
    index_html_file_path = var.gambling_home_config.index_html_file_path
    error_html_file_path = var.gambling_home_config.error_html_file_path
    content_version = var.gambling_home_config.content_version
    assets_path = var.gambling_home_config.assets_path
}

resource "terratowns_home" "gambling_home" {
    name = "How to gamble"
    description = "Just a playground for Terraform"
    domain_name = module.terratowns_gambling.cloudfront_url
    # domain_name = "d22fvnxw4kno2n.cloudfront.net"
    town = "missingo"
    content_version = var.gambling_home_config.content_version
}

module "terratowns_wooden_house" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.teacherseat_user_uuid
    index_html_file_path = var.wooden_home_config.index_html_file_path
    error_html_file_path = var.wooden_home_config.error_html_file_path
    content_version = var.wooden_home_config.content_version
    assets_path = var.wooden_home_config.assets_path
}

resource "terratowns_home" "wooden_home" {
    name = "Lithuania outdoor travel guide"
    description = "Explore the breathtaking landscapes and outdoor adventures of Lithuania with our travel guide. From hiking in lush forests to kayaking on tranquil lakes, discover the natural beauty and rich culture of this Baltic gem."
    domain_name = module.terratowns_wooden_house.cloudfront_url
    # domain_name = "d22fvnxw4kno2n.cloudfront.net"
    town = "the-nomad-pad"
    content_version = var.wooden_home_config.content_version
}

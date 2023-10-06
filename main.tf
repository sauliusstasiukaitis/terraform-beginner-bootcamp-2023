terraform {
    cloud {
        organization = "sauliusstasiukaitis"

        workspaces {
            name = "terra-house-1"
        }
    }
}

module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name
    index_html_file_path = var.index_html_file_path
    error_html_file_path = var.error_html_file_path
    content_version = var.content_version
    assets_path = var.assets_path
}

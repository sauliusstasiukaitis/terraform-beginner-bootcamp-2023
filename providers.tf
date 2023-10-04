terraform {
    cloud {
        organization = "sauliusstasiukaitis"

        workspaces {
            name = "terra-house-1"
        }
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.19.0"
        }
    }
}

provider "aws" {
    # Configuration optionsaws s3api list-buckets
}

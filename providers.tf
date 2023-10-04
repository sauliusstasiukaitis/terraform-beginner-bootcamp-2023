terraform {
    cloud {
        organization = "sauliusstasiukaitis"

        workspaces {
            name = "terra-house-1"
        }
    }

    required_providers {
        random = {
            source = "hashicorp/random"
            version = "3.5.1"
        }

        aws = {
            source = "hashicorp/aws"
            version = "5.19.0"
        }
    }
}

provider "random" {
    # Configuration options
}

provider "aws" {
    # Configuration optionsaws s3api list-buckets
}

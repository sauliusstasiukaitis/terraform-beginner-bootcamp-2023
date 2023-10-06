output "website_bucket" {
    value = module.terrahouse_aws.website_bucket
}

output "s3_website_endpoint" {
    value = module.terrahouse_aws.website_endpoint
}

output "cloudfront_url" {
    value = module.terrahouse_aws.cloudfront_url
}

output "website_bucket_name" {
    description = "Bucket name for our static website hosting"
    value = module.terrahouse_aws.website_bucket_name
}

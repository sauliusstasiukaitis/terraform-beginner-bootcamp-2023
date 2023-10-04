output "website_bucket" {
    value = aws_s3_bucket.website_bucket
}

output "website_endpoint" {
    value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}

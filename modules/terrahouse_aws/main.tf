terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.19.0"
        }
    }
}

resource "aws_s3_bucket" "website_bucket" {
    bucket = var.bucket_name

    tags = {
        UserUuid = var.user_uuid
    }
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "website_index" {
    bucket = aws_s3_bucket.website_bucket.bucket
    key = "index.html"
    source = "${path.root}${var.index_html_file_path}"
    etag = filemd5("${path.root}${var.index_html_file_path}")
}

resource "aws_s3_object" "website_error" {
    bucket = aws_s3_bucket.website_bucket.bucket
    key = "error.html"
    source = "${path.root}${var.error_html_file_path}"
    etag = filemd5("${path.root}${var.error_html_file_path}")
}

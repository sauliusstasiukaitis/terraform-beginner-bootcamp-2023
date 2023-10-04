resource "random_string" "bucket_name" {
    length  = 16
    lower = true
    upper = false
    special = true
    override_special = "-"
}

resource "aws_s3_bucket" "example" {
    bucket = random_string.bucket_name.result

    tags = {
        UserUuid = var.user_uuid
    }
}

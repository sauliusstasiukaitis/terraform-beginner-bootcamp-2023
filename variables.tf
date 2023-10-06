variable "user_uuid" {
    type        = string
    description = "The UUID of the user"
}

variable "bucket_name" {
    type = string
    description = "AWS S3 bucket name"
}

variable "index_html_file_path" {
    type = string
}

variable "error_html_file_path" {
    type = string
}

variable "assets_path" {
    type = string
}

variable "AWS_ACCESS_KEY_ID" {
    type = string
}

variable "AWS_DEFAULT_REGION" {
    type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
    type = string
}

variable "content_version" {
    type        = number
}

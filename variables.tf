variable "user_uuid" {
    type        = string
    description = "The UUID of the user"

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message = "user_uuid must be a valid UUID."
  }
}

variable "bucket_name" {
    type = string
    description = "AWS S3 bucket name"
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

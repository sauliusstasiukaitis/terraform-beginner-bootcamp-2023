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

variable "index_html_file_path" {
    type = string
}

variable "error_html_file_path" {
    type = string
}

variable "content_version" {
    description = "The content version. Should be a positive integer starting at 1."
    type        = number

    validation {
      condition     = var.content_version > 0 && floor(var.content_version) == var.content_version
      error_message = "The content_version must be a positive integer starting at 1."
    }
}

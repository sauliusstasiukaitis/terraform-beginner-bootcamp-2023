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

    validation {
        condition = fileexists(var.index_html_file_path)
        error_message = "The provided path to index file does not exist"
    }
}

variable "error_html_file_path" {
    type = string

    validation {
        condition = fileexists(var.error_html_file_path)
        error_message = "The provided path to error file does not exist"
    }
}

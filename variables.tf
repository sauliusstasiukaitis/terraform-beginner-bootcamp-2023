variable "gambling_home_config" {
  type = object({
    index_html_file_path = string
    error_html_file_path = string
    assets_path = string
    content_version = number
  })
#   default = {
#     index_html_file_path = "gambling/index.html"
#     error_html_file_path = "gambling/error.html"
#     assets_path = "gambling/assets"
#     content_version = 1
#   }
}

variable "wooden_home_config" {
  type = object({
    index_html_file_path = string
    error_html_file_path = string
    assets_path = string
    content_version = number
  })
  description = "A nested configuration variable"
  default = {
    index_html_file_path = "wooden_hause/index.html"
    error_html_file_path = "wooden_hause/error.html"
    assets_path = "wooden_hause/assets"
    content_version = 5
  }
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

variable "terratowns_endpoint" {
    type = string
}

variable "terratowns_access_token" {
    type = string
}

variable "teacherseat_user_uuid" {
    type = string
}

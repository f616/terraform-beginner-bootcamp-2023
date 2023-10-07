variable "terratowns_endpoint" {
  type        = string
}

variable "terrarowns_access_token" {
  type        = string
}

variable "teacherseat_user_uuid" {
  type        = string
}

variable "home01" {
  type = object({
    public_path = string
    content_version = number
  })
}

variable "home02" {
  type = object({
    public_path = string
    content_version = number
  })
}
variable "bucket_name" {
  type = string
}
variable "environment" {
  type = string
}

variable "enable_logging" {
  type    = bool
  default = false
}


variable "log_bucket" {
  type = string
  default = null
}
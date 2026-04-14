variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "ports" {
  default = [80,443]
}
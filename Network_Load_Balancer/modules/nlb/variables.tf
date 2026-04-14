variable "public_subnet_1" {
  description = "public_subnet_1"
  type = string
}
variable "public_subnet_2" {
  description = "public_subnet_2"
  type = string
}
# variable "nlb_sg" {
#   description = "network lb sg "
#   type = string
# }
variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "ec1-1-id" {
  description = "instance 1 id"
  type = string
}

variable "ec1-2-id" {
  description = "instance 2 id"
  type = string
}
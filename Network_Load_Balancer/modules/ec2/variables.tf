variable "ami_id" {
  description = "ami_id"
  type = string
}

variable "instance_type" {
  description = "instance type"
  type = string
}

variable "public_subnet_1" {
  description = "public_subnet_1"
  type = string
}
variable "public_subnet_2" {
  description = "public_subnet_2"
  type = string
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "sg_id" {
  description = "security grp"
}
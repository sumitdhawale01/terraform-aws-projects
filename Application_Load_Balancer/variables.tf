variable "ami" {
  description = "ami value"
  type = string
}

variable "instance_type" {
  description = "instance type"
  type = string
}


variable "vpc_cidr" {
  description = "vpc cidr value"
  type = string
}
variable "subnet_cidr_block" {
  description = "subnet cidr block"
}
variable "subnet2_cidr_block" {
  description = "subnet 2 cidr block"
}


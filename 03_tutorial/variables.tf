variable "ami" {
  description = "value of the ami"
}

variable "instance_type" {
  description = "value of the instance type"
  type = string
#   default = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID for EC2"
  type        = string
}
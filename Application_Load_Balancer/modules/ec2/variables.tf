variable "ami" {
  description = "ami value"
  type = string
}

variable "instance_type" {
  description = "instance type"
  type = string
}

variable "subnet_id_01" {
  description = "subnet id"
  type = string
}
variable "subnet_id_02" {
  description = "subnet id"
  type = string
}

variable "sg_id" {
  type = string
}
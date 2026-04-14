variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "subnet_id_01" {
  description = "sub 1 id"
}
variable "subnet_id_02" {
  description = "sub 2 id"
}
variable "sg_id" {
  description = "sg id"
}

variable "app1_id" {
  description = "EC2 instance 1 ID"
  type        = string
}

variable "app2_id" {
  description = "EC2 instance 2 ID"
  type        = string
}
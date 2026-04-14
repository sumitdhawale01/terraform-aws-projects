variable "vpc_cidr" {
  description = "cidr value of vpc"
  type = string
}

variable "sub1_cidr" {
  description = "cidr value of subnet 1"
  type = string

}

variable "az_1" {
    description = "availabily zone of subnet 1"
    type = string  
}

variable "sub2_cidr" {
  description = "cidr value of subnet 2"
  type = string
}

variable "az_2" {
    description = "availabily zone of subnet 1"
    type = string

}

variable "private_sub_01_cidr" {
  description = "cidr value of private subnet 1"
  type = string
}

variable "private_sub_02_cidr" {
  description = "cidr value of private subnet 2"
  type = string
}


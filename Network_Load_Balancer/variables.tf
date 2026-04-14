variable "ami_id" {
  description = "ami value"
  type = string
}

variable "instance_type" {
  description = "instance type"
  type = string
}

variable "subnet_id" {
    description = "subnet id"  
    type = string
  
}

variable "cidr_block" {
  description = "vpc cidr block"
  type = string
}

variable "cidr_block_pub_1" {
  description = "cidr bloack for first public subnet"
  type = string

}

variable "cidr_block_pub_2" {
  description = "cidr bloack for second public subnet"
  type = string
}


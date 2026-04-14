provider "aws" {
    region = "ap-south-1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_value =  "ami-045443a70fafb8bbc"
  subnet_id = "subnet-0b0189c61e834f190"
  instance_type_value = "t3.micro"
}
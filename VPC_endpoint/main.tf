provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnet" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
  private_cidr_1 = var.private_cidr_1
  availability_zone = var.availability_zone
}


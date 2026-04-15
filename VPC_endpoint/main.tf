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

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "rt" {
  source = "./modules/rt"
  vpc_id = module.vpc.vpc_id
  private_subnet_1 = module.subnet.private_subnet_1
}

module "iam" {
  source = "./modules/iam"

}

module "vpc_endpoints" {
  source = "./modules/vpc_endpoints"
  sg_id = module.sg.sg_id
  vpc_id = module.vpc.vpc_id
  private_subnet_1 = module.subnet.private_subnet_1

}

module "ec2" {
  source = "./modules/ec2"
  sg_id = module.sg.sg_id
  instance_profile_name = module.iam.instance_profile_name
  private_subnet_1 = module.subnet.private_subnet_1
  instance_type = var.instance_type
  ami = var.ami

}

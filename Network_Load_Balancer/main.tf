provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block = var.cidr_block
}

module "subnet" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc-id
  cidr_block_pub_1 = var.cidr_block_pub_1
  cidr_block_pub_2 = var.cidr_block_pub_2
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc-id
}

module "ec2" {
  source = "./modules/ec2"
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  sg_id = module.sg.sg-id
  vpc_id = module.vpc.vpc-id
  public_subnet_1 = module.subnet.public_subnet_1
  public_subnet_2 = module.subnet.public_subnet_2

}

module "rt" {
  source = "./modules/rt"
  public_subnet_1 = module.subnet.public_subnet_1
  public_subnet_2 = module.subnet.public_subnet_2
  vpc_id = module.vpc.vpc-id
}

module "nlb" {
  source = "./modules/nlb"
  ec1-1-id = module.ec2.ec1-1-id
  ec1-2-id = module.ec2.ec1-2-id
  public_subnet_1 = module.subnet.public_subnet_1
  public_subnet_2 = module.subnet.public_subnet_2
  vpc_id = module.vpc.vpc-id
  # nlb_sg = module.sg.nlb_sg
}
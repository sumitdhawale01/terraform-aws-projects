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
  subnet_cidr_block = var.subnet_cidr_block
  subnet2_cidr_block = var.subnet2_cidr_block
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
  sg_id = module.sg.sg_id
}


module "ec2" {
  source = "./modules/ec2"

  ami            = var.ami
  instance_type  = var.instance_type

  subnet_id_01   = module.subnet.subnet_id_01
  subnet_id_02   = module.subnet.subnet_id_02

  sg_id          = module.sg.sg_id
}


module "RT" {
  source = "./modules/RT"

  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id
  subnet_id_01 = module.subnet.subnet_id_01
  subnet_id_02 = module.subnet.subnet_id_02
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnet_id_01 = module.subnet.subnet_id_01
  subnet_id_02 = module.subnet.subnet_id_02
  sg_id = module.sg.alb_sg_id

  app1_id =   module.ec2.app1_id
  app2_id =  module.ec2.app2_id
  
}
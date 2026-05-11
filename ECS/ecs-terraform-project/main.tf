
module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/sg"

  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"
 
  subnet_id = module.vpc.subnet1

  security_group = module.sg.ec2_sg
  ami = var.ami

  key_name = var.key_name
}

module "ecr" {
  source = "./modules/ecr"

}
module "alb" {
  source = "./modules/alb"

  vpc_id = module.vpc.vpc_id

  subnet1 = module.vpc.subnet1
  subnet2 = module.vpc.subnet2

  alb_sg = module.sg.alb_sg
}

module "ecs" {
  source = "./modules/ecs"

  subnet1 = module.vpc.subnet1
  subnet2 = module.vpc.subnet2

  security_group = module.sg.ec2_sg

  target_group_arn = module.alb.target_group_arn

  ecr_image = "${module.ecr.repository_url}:latest"
}
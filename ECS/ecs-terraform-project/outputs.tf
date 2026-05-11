output "public_ip" {
  value = module.ec2.public_ip
}

output "ecr_url" {
  value = module.ecr.repository_url
}

output "alb_dns" {
  value = module.alb.alb_dns
}
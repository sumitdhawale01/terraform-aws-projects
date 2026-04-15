

resource "aws_vpc_endpoint" "ssm" {
  
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.ap-south-1.ssm"
    vpc_endpoint_type = "Interface"

    subnet_ids = [var.private_subnet_1]
    security_group_ids = [ var.sg_id ]

    private_dns_enabled = true

}

resource "aws_vpc_endpoint" "ec2messages" {
  
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.ap-south-1.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [var.private_subnet_1]
  security_group_ids = [ var.sg_id ]
  private_dns_enabled = true    
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.ap-south-1.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [var.private_subnet_1]
  security_group_ids = [var.sg_id]

  private_dns_enabled = true
}


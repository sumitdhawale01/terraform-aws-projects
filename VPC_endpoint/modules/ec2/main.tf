

resource "aws_instance" "private_ec2" {
  ami = var.ami
  
  instance_type = var.instance_type

  subnet_id = var.private_subnet_1

  vpc_security_group_ids = [var.sg_id]

  iam_instance_profile = var.instance_profile_name

  associate_public_ip_address = false

  tags = {
    Name = "private-ec2"
  }
}
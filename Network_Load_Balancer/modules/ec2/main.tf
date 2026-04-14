provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "ec2-1" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.public_subnet_1
  vpc_security_group_ids = [ var.sg_id ]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>This is App1</h1>" > /var/www/html/index.html
              EOF


  tags = {
    Name = "TEST-1"
  }

}


resource "aws_instance" "ec2-2" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.public_subnet_2
  vpc_security_group_ids = [ var.sg_id ]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>This is App2</h1>" > /var/www/html/index.html
              EOF


  tags = {
    Name = "TEST-2"
  }

}
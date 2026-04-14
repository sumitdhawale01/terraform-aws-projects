provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "app1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id_01
  vpc_security_group_ids = [var.sg_id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>This is App1</h1>" > /var/www/html/index.html
              EOF

  

  tags = {
    Name = "app1"
  }
}

resource "aws_instance" "app2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id_02
  vpc_security_group_ids = [var.sg_id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>This is App2</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "app2"
  }
}
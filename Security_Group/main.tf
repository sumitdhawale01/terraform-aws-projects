provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "e1" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id

  security_groups = [ aws_security_group.Sec_grp.id ]

  tags = {
    Name = "Instance_01"
  }
}

resource "aws_security_group" "Sec_grp" {
    

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
resource "aws_iam_role" "ec2_role" {
  name = "ecs-project-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "profile" {
  name = "ecs-project-profile"

  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "ec2" {

  ami           = var.ami
  instance_type = "t3.micro"

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.security_group
  ]

  key_name = var.key_name

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.profile.name

  tags = {
    Name = "docker-build-server"
  }
}
resource "aws_ecs_cluster" "cluster" {
  name = "flask-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {

  name = "ecsTaskExecutionRole_01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {

  role = aws_iam_role.ecs_task_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "/ecs/flask-app"
}   

resource "aws_ecs_task_definition" "task" {

  family = "flask-task"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "flask-container"

      image = var.ecr_image

      essential = true

      portMappings = [
        {
          containerPort = 8081
          hostPort      = 8081
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.logs.name
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "service" {

  name = "flask-service"

  cluster = aws_ecs_cluster.cluster.id

  task_definition = aws_ecs_task_definition.task.arn

  desired_count = 2

  launch_type = "FARGATE"

  network_configuration {

    subnets = [
      var.subnet1,
      var.subnet2
    ]

    security_groups = [
      var.security_group
    ]

    assign_public_ip = true
  }

  load_balancer {

    target_group_arn = var.target_group_arn

    container_name = "flask-container"

    container_port = 8081
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution_policy
  ]
}

# auto scaling

resource "aws_appautoscaling_target" "ecs_target" {

  max_capacity = 5

  min_capacity = 2

  resource_id = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.service.name}"

  scalable_dimension = "ecs:service:DesiredCount"

  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {

  name = "ecs-auto-scaling"

  policy_type = "TargetTrackingScaling"

  resource_id = aws_appautoscaling_target.ecs_target.resource_id

  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension

  service_namespace = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {

    predefined_metric_specification {

      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 70

    scale_in_cooldown  = 60

    scale_out_cooldown = 60
  }
}
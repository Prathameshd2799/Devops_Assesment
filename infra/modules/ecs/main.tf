# ECS Cluster

resource "aws_ecs_cluster" "cluster" {
  name = "assessment-cluster"

  tags = {
    Name = "assessment-cluster"
  }
}

# ECS Security Group


resource "aws_security_group" "ecs_sg" {
  name        = "ecs-security-group"
  description = "Security Group for ECS"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # पुढे ALB SG ने replace करू
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg"
  }
}

# ALB Security Group

resource "aws_security_group" "alb_sg" {

  name   = "alb-security-group"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Application Load Balancer

resource "aws_lb" "alb" {

  name = "assessment-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    var.public_subnet_id,
    var.public_subnet_id_2
  ]
}

# Target Group

resource "aws_lb_target_group" "tg" {

  name = "assessment-tg"

  port = 80

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id
}

# Listener
resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# IAM Role

resource "aws_iam_role" "ecs_execution_role" {

  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Action = "sts:AssumeRole"

        Effect = "Allow"

        Principal = {

          Service = "ecs-tasks.amazonaws.com"

        }

      }

    ]

  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# Task Definition

resource "aws_ecs_task_definition" "task" {

  family = "assessment-task"

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu = var.cpu

  memory = var.memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([

    {

      name = "nginx"

      image = "nginx:latest"

      essential = true

      portMappings = [

        {

          containerPort = 80

          hostPort = 80

          protocol = "tcp"

        }

      ]

    }

  ])
}

# ECS Service

resource "aws_ecs_service" "service" {

  name = "assessment-service"

  cluster = aws_ecs_cluster.cluster.id

  task_definition = aws_ecs_task_definition.task.arn

  desired_count = 2

  launch_type = "FARGATE"

  network_configuration {

    subnets = [

      var.public_subnet_id

    ]

    security_groups = [

      aws_security_group.ecs_sg.id

    ]

    assign_public_ip = true
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.tg.arn

    container_name = "nginx"

    container_port = 80
  }

  depends_on = [

    aws_lb_listener.listener

  ]
}
resource "aws_security_group" "ecs_sg" {

  name        = "ecs-security-group"
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    security_groups = [aws_security_group.alb_sg.id]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}
resource "aws_security_group" "alb_sg" {

  name = "alb-security-group"

  description = "Allow HTTP"

  vpc_id = var.vpc_id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}
resource "aws_iam_role" "ecs_execution_role" {

  name = "ecsTaskExecutionRole"

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
resource "aws_iam_role_policy_attachment" "ecs_execution" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

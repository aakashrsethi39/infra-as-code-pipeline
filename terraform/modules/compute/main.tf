resource "aws_ecs_cluster" "main" {

  name = "ecommerce-${var.environment}-cluster"

  tags = {
    Environment = var.environment
    Project     = "ecommerce"
    ManagedBy   = "Terraform"
  }

}
resource "aws_lb" "main" {

  name = "ecommerce-${var.environment}-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group
  ]

  subnets = [
    var.public_subnet1,
    var.public_subnet2
  ]

  tags = {
    Environment = var.environment
    Project     = "ecommerce"
  }

}

resource "aws_lb_target_group" "main" {

  name = "ecommerce-${var.environment}-tg"

  port = 3000

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    path = "/health"

    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2

  }

  tags = {
    Environment = var.environment
  }

}


resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.main.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.main.arn

  }

}
resource "aws_ecs_task_definition" "app" {

  family = "ecommerce-${var.environment}"

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu = "256"

  memory = "512"

  execution_role_arn = var.execution_role_arn

  container_definitions = jsonencode([

    {

      name = "app"

      image = "${var.repository_url}:latest"

      essential = true

      portMappings = [

        {

          containerPort = 3000

          hostPort = 3000

        }

      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = var.log_group_name

          awslogs-region = var.region

          awslogs-stream-prefix = "ecs"

        }

      }

    }

  ])

}
resource "aws_ecs_service" "app" {

  name = "ecommerce-${var.environment}-service"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.app.arn

  desired_count = 2

  launch_type = "FARGATE"

  network_configuration {

    subnets = [

      var.public_subnet1,

      var.public_subnet2

    ]

    security_groups = [

      var.ecs_security_group

    ]

    assign_public_ip = true

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.main.arn

    container_name = "app"

    container_port = 3000

  }

  depends_on = [

    aws_lb_listener.http

  ]

}
resource "aws_appautoscaling_target" "ecs" {

  max_capacity = 6
  min_capacity = 2

  resource_id = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.app.name}"

  scalable_dimension = "ecs:service:DesiredCount"

  service_namespace = "ecs"

}
resource "aws_appautoscaling_policy" "cpu" {

  name = "ecs-${var.environment}-cpu-scaling"

  policy_type = "TargetTrackingScaling"

  resource_id = aws_appautoscaling_target.ecs.resource_id

  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension

  service_namespace = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {

    predefined_metric_specification {

      predefined_metric_type = "ECSServiceAverageCPUUtilization"

    }

    target_value = 70

  }

}

resource "aws_appautoscaling_policy" "memory" {

  name = "ecs-${var.environment}-memory-scaling"

  policy_type = "TargetTrackingScaling"

  resource_id = aws_appautoscaling_target.ecs.resource_id

  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension

  service_namespace = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {

    predefined_metric_specification {

      predefined_metric_type = "ECSServiceAverageMemoryUtilization"

    }

    target_value = 75

  }

}

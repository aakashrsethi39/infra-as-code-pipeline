output "ecs_security_group" {

  value = aws_security_group.ecs_sg.id

}

output "alb_security_group" {

  value = aws_security_group.alb_sg.id

}

output "execution_role" {

  value = aws_iam_role.ecs_execution_role.arn

}
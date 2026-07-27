variable "cluster_name" {
  type    = string
  default = "ecommerce-cluster"
}

variable "execution_role_arn" {}

variable "ecs_security_group" {}

variable "alb_security_group" {}

variable "public_subnet1" {}

variable "public_subnet2" {}

variable "vpc_id" {}

variable "repository_url" {}

variable "log_group_name" {}

variable "region" {
  default = "ap-south-1"
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
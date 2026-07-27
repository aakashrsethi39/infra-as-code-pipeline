variable "log_group_name" {
  description = "CloudWatch Log Group Name"
  type        = string
  default     = "/ecs/ecommerce"
}

variable "retention_days" {
  description = "Retention period for logs"
  type        = number
  default     = 14
}
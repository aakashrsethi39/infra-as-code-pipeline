locals {

  project_name = "ecommerce"

  environment = terraform.workspace

  aws_region = var.region

  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
  }

}
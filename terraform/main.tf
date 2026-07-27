module "networking" {

  source = "./modules/networking"

  region = var.region

  vpc_cidr = var.vpc_cidr

}
module "security" {

  source      = "./modules/security"
  environment = terraform.workspace

  vpc_id = module.networking.vpc_id

}
module "ecr" {
  source = "./modules/ecr"

  environment = terraform.workspace
}

module "monitoring" {

  source = "./modules/monitoring"

  log_group_name = "/ecs/ecommerce"

  retention_days = 14

}

module "compute" {

  source = "./modules/compute"

  execution_role_arn = module.security.execution_role

  ecs_security_group = module.security.ecs_security_group

  alb_security_group = module.security.alb_security_group

  public_subnet1 = module.networking.public_subnet1

  public_subnet2 = module.networking.public_subnet2

  vpc_id = module.networking.vpc_id

  repository_url = module.ecr.repository_url

  log_group_name = module.monitoring.log_group_name

  region      = var.region
  environment = terraform.workspace

}

output "cluster_name" {
  value = module.compute.cluster_name
}

output "service_name" {
  value = module.compute.service_name
}

output "task_definition_family" {
  value = module.compute.task_definition_family
}

output "container_name" {
  value = module.compute.container_name
}

output "repository_url" {
  value = module.ecr.repository_url
}

output "alb_dns_name" {
  value = module.compute.alb_dns_name
}
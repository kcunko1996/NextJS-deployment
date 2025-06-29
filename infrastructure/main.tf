module "vpc" {
  source = "./modules/vpc"

  name_prefix             = var.project_name
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  enable_nat_gateway     = var.enable_nat_gateway
  container_port         = var.container_port
}

module "ecr" {
  source = "./modules/ecr"

  repository_name              = var.project_name
  environment                  = var.environment
}

module "alb" {
  source = "./modules/alb"

  alb_name                   = "${var.project_name}-alb"
  target_group_name          = "${var.project_name}-tg"
  certificate_arn            = var.certificate_arn
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  alb_security_group_id      = module.vpc.alb_security_group_id
  container_port             = var.container_port
  health_check_path          = "/"
  enable_deletion_protection = false
  environment                = var.environment
}


module "ecs" {
  source = "./modules/ecs"

  cluster_name           = "${var.project_name}-cluster"
  service_name          = "${var.project_name}-service"
  container_name        = var.project_name
  container_image       = "${module.ecr.repository_url}:latest"
  container_port        = var.container_port
  cpu                   = var.cpu
  memory                = var.memory
  desired_count         = var.desired_count
  environment           = var.environment
  aws_region            = var.aws_region
  
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.vpc.ecs_security_group_id
  
  target_group_arn      = module.alb.target_group_arn
  alb_listener_arn      = module.alb.listener_arn
  
  environment_variables = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "PORT"
      value = "3000"
    }
  ]
  
  health_check_command = "curl -f http://127.0.0.1:3000/ || exit 1"
  log_retention_days   = 7
  
  enable_autoscaling = false
}

module "route53" {
  source = "./modules/route53"
  domain_name         = var.domain_name
  root_domain         = var.root_domain
  alb_dns_name       = module.alb.alb_dns_name
  alb_zone_id         = module.alb.alb_zone_id
}
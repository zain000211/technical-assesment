module "vpc" {
  source = "./modules/vpc"
  vpc_cidr  = var.vpc_cidr
}

module "sg" {
  source  = "./modules/sg"
  vpc_id  = module.vpc.aws_vpc.main.id
}
module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.aws_vpc.main.id
  app_react_tg  = var.app_react_tg
  app_svelte_tg = var.app_svelte_tg
  security_groups = module.sg.aws_security_group.alb_sg.id
  subnets = module.vpc.aws_subnet.public[*].id
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "iam" {
  source = "./modules/iam"
  ecs_service_iam_role    = var.ecs_service_iam_role
  ecs_task_role_name      = var.ecs_task_role_name
  ecs_task_execution_role = var.ecs_task_execution_role
}

module "ecr" {
  source = "./modules/ecr"
  repository_names  = var.repository_names
}

module "rds" {
  source            = "./modules/rds"
  primary_rds_name  = var.primary_rds_name
  secondry_rds_name = var.secondry_rds_name
  instance_class    = var.instance_class
  storage           = var.storage
  db_name           = var.db_name
  backup_retention_period = var.backup_retention_period
  secret_manager_arn      = var.secret_manager_arn
}

module "ecs" {
  source            = "./modules/ecs"
  ecs_cluster_name  = var.ecs_cluster_name
}

module "ecs_service" {
  source = "./modules/ecs_service"
  ecs_cluster_id      = module.ecs.aws_ecs_cluster.main.id
  service_names       = var.service_names
  repository_names    = module.ecr.aws_ecr_repository.repositories[*].name
  image_version       = var.image_version
  execution_role_arn  = module.iam.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn       = module.iam.aws_iam_role.ecs_task_role.arn
  subnets             = module.vpc.aws_subnet.private[*].id
  security_groups     = module.sg.aws_security_group.alb_sg.id
  react_tg_arn        = aws_lb_target_group.app-react-tg.arn
  svelte_tg_arn       = aws_lb_target_group.app-svelte-tg.arn
  rds_endpoint        = module.rds.aws_db_instance.primary_rds.endpoint
}

module "ecs_scaling" {
  source                     = "./modules/ecs_scaling"
  ecs_cluster                = var.ecs_cluster_name
  php_max_capacity           = var.php_max_capacity
  php_min_capacity           = var.php_min_capacity
  microservice_max_capacity  = var.microservice_max_capacity
  microservice_min_capacity  = var.microservice_min_capacity
  ecs_service_name_1         = "php"
  ecs_service_name_2         = "microservice"
}

module "route53" {
  source       = "./modules/route53"
  domain_name  = var.domain_name
}

module "acm" {
  source      = "./modules/acm"
  domain_name = var.domain_name
  zone_id     = module.route53.aws_route53_zone.domain_zone.id
}

module "cloudfront" {
  source              = "./modules/cloudfront"
  domain_name         = module.aws_s3_bucket.main.bucket_regional_domain_name
  acm_certificate_arn = module.acm.aws_acm_certificate.acm_cert.arn
}

module "waf" {
  source    = "./modules/waf"
  waf_name  = var.waf_name
  alb_arn   = module.alb.aws_lb.app_alb.arn
}


module "route53_failover" {
  source = "./modules/route53_failover"
  alb_dns_name        = module.alb.aws_lb.app_alb.dns_name
  alb_zone_id         = module.alb.aws_lb.app_alb.zone_id
  passive_alb_zone_id = module.alb.aws_lb.passive_app_alb.zone_id
  passive_alb_dns_name = module.alb.aws_lb.passive_app_alb.dns_name
  zone_id             = module.route53.aws_route53_zone.domain_zone.zone_id
}

variable "region" {
  description = "Primary AWS region"
  type        = string
}

variable "secondary_region" {
  description = "Secondary AWS region for multi-region DB"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "ecs_cluster_name" {
  type    = string
  default = "KC-dev-react"
}

variable "repository_names" {
  description = "List of repository names to create in ECR"
  type        = list(string)
  default     = ["react-app", "svelte-app", "php-app", "microservice-app", "python-server"]
}

variable "app_react_tg" {
  type    = string
  default = "app-react-tg"
}

variable "app_svelte_tg" {
  type    = string
  default = "app-svelte-tg"
}

variable "ecs_service_iam_role" {
  type    = string
  default = "kc-ecs-service-role"
}

variable "ecs_task_role_name" {
  type    = string
  default = "kc-ecs-task-role"
}

variable "ecs_task_execution_role" {
  type    = string
  default = "kc-task-execution-role"
}

variable "php_max_capacity" {
  default = 5
}

variable "php_min_capacity" {
  default = 1
}

variable "microservice_max_capacity" {
  default = 5
}

variable "microservice_min_capacity" {
  default = 1
}

variable "service_names" {
  description = "List of service names"
  type        = list(string)
  default     = ["react", "svelte", "php", "microservice", "python"]
}

variable "image_version" {
  description = "docker image version of services"
  type        = list(string)
  default     = ["latest", "latest", "latest", "latest", "latest"]
}


variable "primary_rds_name" {
  default = "primary-mysql-db"
}

variable "secondry_rds_name" {
  default = "secondry-mysql-db"
}

variable "instance_class" {
  default = "db.t3.medium"
}

variable "storage" {
  default = 20
}

variable "db_name" {
  default = "kcdb"
}

variable "backup_retention_period" {
  default = 7
}

variable "domain_name" {
  default = "kc.com"
}

variable "var.waf_name" {
  default = "kc-waf" 
}

variable "secret_manager_arn" {
  description = "ARN of the Secrets Manager secret containing RDS credentials"
  type        = string
}
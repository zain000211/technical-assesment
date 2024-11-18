locals {
  services = [
    for idx, name in var.service_names : {
      name  = name
      image = "${var.repository_names[idx]}:${var.image_version[idx]}"
    }
  ]
}



resource "aws_ecs_task_definition" "service_task" {
  for_each = { for service in local.services : service.name => service }

  family                = "${each.value.name}-task"
  execution_role_arn    = var.execution_role_arn
  task_role_arn         = var.task_role_arn
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"
  container_definitions = jsonencode([
    {
      name      = "${each.value.name}-container"
      image     = each.value.image
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        for service in local.services : {
          name  = "DB_CONNECTION"
          value = var.rds_endpoint
        } if each.value.name == "php"
      ]
    }
  ])
}


resource "aws_ecs_service" "ecs_service_react" {
  name            = "react"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.service_task[each.key].arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnets
    security_groups = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.react_tg_arn
    container_name   = "react-container"
    container_port   = 80
  }
}

resource "aws_ecs_service" "ecs_service_svelte" {

  name            = "react"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.service_task[each.key].arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnets
    security_groups = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.svelte_tg_arn
    container_name   = "svelte-container"
    container_port   = 80
  }
}
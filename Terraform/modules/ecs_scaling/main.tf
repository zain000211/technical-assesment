resource "aws_appautoscaling_target" "php_service_scaling_target" {
  max_capacity = var.php_max_capacity
  min_capacity = var.php_min_capacity
  resource_id = "service/${var.ecs_cluster}/${var.ecs_service_name_1}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}


resource "aws_appautoscaling_policy" "php_scale_up" {
  name               = "php-scale-on-memory"
  scaling_adjustment = 1
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.php_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.php_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.php_service_scaling_target.service_namespace
  metric_aggregation_type = "SampleCount"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 75
  }
}


resource "aws_appautoscaling_target" "microservice_service_scaling_target" {
  max_capacity = var.microservice_max_capacity
  min_capacity = var.microservice_min_capacity
  resource_id = "service/${var.ecs_cluster}/${var.ecs_service_name_2}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}


resource "aws_appautoscaling_policy" "microservice_scale_up" {
  name = "microservice-scale-on-cpu"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.microservice_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.microservice_service_scaling_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.microservice_service_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 80
  }
}

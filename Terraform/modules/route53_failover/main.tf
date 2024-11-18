resource "aws_route53_health_check" "active" {
  type = "HTTP"
  resource_path = "/health"
  failure_threshold = 3
  request_interval = 10

  tags = {
    Name = "Active Region Health Check"
  }
}

resource "aws_route53_health_check" "passive" {
  type = "HTTP"
  resource_path = "/health"
  failure_threshold = 3
  request_interval = 10

  tags = {
    Name = "Passive Region Health Check"
  }
}

resource "aws_route53_record" "dns_failover" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  set_identifier = "Active Region"
  health_check_id = aws_route53_health_check.active.id
  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }

  set_identifier = "Passive Region"
  health_check_id = aws_route53_health_check.passive.id
  alias {
    name = var.passive_alb_dns_name
    zone_id = var.passive_alb_zone_id
    evaluate_target_health = true
  }
}
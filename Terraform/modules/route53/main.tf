resource "aws_route53_zone" "domain_zone" {
  name         = var.domain_name
}


resource "aws_route53_record" "kc_com" {
  zone_id = aws_route53_zone.domain_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
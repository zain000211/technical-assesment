resource "aws_acm_certificate" "acm_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]

}

resource "aws_route53_record" "certificate_dns" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_type
  zone_id = var.zone_id
  ttl = 60
}
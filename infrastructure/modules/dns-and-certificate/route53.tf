resource "aws_route53_record" "generic_certificate_validation" {
  name    = tolist(aws_acm_certificate.alb_certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.alb_certificate.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.service.id
  records = [tolist(aws_acm_certificate.alb_certificate.domain_validation_options)[0].resource_record_value]
  ttl     = 300
}


resource "aws_route53_record" "alias_to_alb" {
  zone_id = data.aws_route53_zone.service.zone_id 
  name    = var.dns_name
  type    = "A"

  alias {
    name                   = var.forward_to_dns_name
    zone_id                = var.forward_to_zone_id
    evaluate_target_health = true
  }
}

## This module is used to
##  1) create a certificate, validate it
##  2) register a DNS record, in route53
##  3) create an alias record to the ALB (in route53) to connect to the dms name (from ALB, provided as a variable)

resource "aws_acm_certificate" "alb_certificate" {
  domain_name               = var.dns_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.dns_name}"]
}

resource "aws_acm_certificate_validation" "alb_certificate" {
  certificate_arn         = aws_acm_certificate.alb_certificate.arn
  validation_record_fqdns = [aws_route53_record.generic_certificate_validation.fqdn]
}








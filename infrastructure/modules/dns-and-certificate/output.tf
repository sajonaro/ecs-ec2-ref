output "certificate_arn" {
  description = "value of the generated certificate arn"
  value = aws_acm_certificate.alb_certificate.arn
}
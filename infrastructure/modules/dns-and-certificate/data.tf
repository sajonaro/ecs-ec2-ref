
## assuming DNS name already exists
data "aws_route53_zone" "service" {
  name = "${var.dns_name}"
  private_zone = false 
}
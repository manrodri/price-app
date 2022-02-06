resource "aws_route53_zone" "main" {
  name = var.domain_name
}


# Standard route53 DNS record for "myapp" pointing to an ALB
resource "aws_route53_record" "myapp" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${terraform.workspace}.${aws_route53_zone.main.name}"
  type    = "A"
  alias {
    name                   = aws_alb.webapp_alb.dns_name
    zone_id                = aws_alb.webapp_alb.zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.myapp.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.myapp.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.myapp.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.main.zone_id
  ttl             = 300
}
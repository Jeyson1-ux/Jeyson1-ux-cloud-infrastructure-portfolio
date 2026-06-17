data "aws_route53_zone" "main" {
  name         = "devvie.se" # your domain
  private_zone = false       # public hosted zone
}

resource "aws_acm_certificate" "main" {
  domain_name       = "app.devvie.se" # your domain
  validation_method = "DNS"           # public hosted zone

  tags = {
    Name = "${var.project_name}-cert"
  }

  lifecycle {
    create_before_destroy = true # create new cert before destroying old one
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name  # CNAME record name from AWS
      type   = dvo.resource_record_type  # record type (CNAME)
      record = dvo.resource_record_value # C
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id # which hosted zone
  name    = each.value.name                    # record name
  type    = each.value.type                    # record type
  ttl     = 60                                 #cache for 6o seconds
  records = [each.value.record]                # record value

}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn                                     # which cert to validate
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn] # wait for DNS
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id # A hosted zone
  name    = "app.devvie.se"
  type    = "A" # A record type

  alias {
    name                   = aws_lb.main.dns_name # ALB DNS NAME
    zone_id                = aws_lb.main.zone_id  # ALB hosted zone
    evaluate_target_health = true                 # check if ALB is healthy before routing
  }

}
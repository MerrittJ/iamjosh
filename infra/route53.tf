resource "aws_route53_zone" "iamjosh_zone" {
  name = var.domain_name
}

resource "aws_route53_zone" "blog_iamjosh_zone" {
  name = "blog.${var.domain_name}"
}

resource "aws_route53_record" "blog-ns" {
  zone_id = aws_route53_zone.iamjosh_zone.zone_id
  name    = "blog.${var.domain_name}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.blog_iamjosh_zone.name_servers
}

resource "aws_acm_certificate" "iamjosh_certificate_request" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name : var.domain_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "iamjosh_validation_record" {
  zone_id = aws_route53_zone.iamjosh_zone.zone_id
  for_each = {
    for dvo in aws_acm_certificate.iamjosh_certificate_request.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 172800
}

# resource to wait for certificate validation
resource "aws_acm_certificate_validation" "iamjosh_certificate_validation" {
  certificate_arn         = aws_acm_certificate.iamjosh_certificate_request.arn
  validation_record_fqdns = [for record in aws_route53_record.iamjosh_validation_record : record.fqdn]
}

resource "aws_route53_record" "webpage_ipv4_record" {
  zone_id = var.r53_zone_id
  name    = var.custom_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = "Z2FDTNDATAQYW2" // default for CloudFront
    evaluate_target_health = false
  }
}

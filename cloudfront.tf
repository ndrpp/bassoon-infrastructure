resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.bucket_web_configuration.website_endpoint
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
    origin_id = "S3OriginId"
    custom_header {
      name  = "Referer"
      value = var.referer_header
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  aliases = [var.custom_domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3OriginId"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 86400

    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers_policy.id
  }

  custom_error_response {
      error_caching_min_ttl = 86400
          error_code = 404
          response_code = 404
          response_page_path = "/404.html"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["RU", "CN", "KP"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name = "custom-security-headers-policy"
  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override     = true
    }
    referrer_policy {
      referrer_policy = "same-origin"
      override        = true
    }
    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
    strict_transport_security {
      access_control_max_age_sec = "63072000"
      include_subdomains         = true
      preload                    = true
      override                   = true
    }
    content_security_policy {
      content_security_policy = "default-src 'self'; font-src 'self' https://cdn.jsdelivr.net/npm/katex@0.16.7/dist/fonts; form-action 'none'; base-uri 'none'; frame-ancestors 'none'; connect-src 'self'; img-src 'self'; script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net/npm/katex@0.16.7/dist/katex.min.js https://cdn.jsdelivr.net/npm/katex@0.16.7/dist/contrib/auto-render.min.js; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net/npm/katex@0.16.7/dist/katex.min.css; require-trusted-types-for 'script'"
      override                = true
    }
  }
}

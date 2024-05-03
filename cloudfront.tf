resource "aws_cloudfront_origin_access_control" "cf_bucket_oac" {
  name                              = var.bucket_name
  description                       = "Setting to allow access to the S3 bucket only from CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_origin_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cf_bucket_oac.id
    origin_id                = "S3OriginId"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  //aliases = [var.custom_domain_name]

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

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["RU"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

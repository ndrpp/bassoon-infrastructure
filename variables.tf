variable "bucket_name" {
  type        = string
  description = "Name of the S3 Bucket to host the static files."
}

variable "custom_domain_name" {
  type        = string
  description = "Custom domain name for your distribution."
}

variable "referer_header" {
  type        = string
  description = "Referer header used to allow access to S3 only from CloudFront"
}

variable "certificate_arn" {
    type = string
    description = "ARN of the SSL certificate in ACM (must be in us-east-1 for CloudFront!)"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 Bucket to host the static files."
}

variable "custom_domain_name" {
  type        = string
  description = "Custom domain name for your distribution."
}

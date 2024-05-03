resource "aws_s3_bucket" "website_origin_bucket" {
  bucket = var.bucket_name
}

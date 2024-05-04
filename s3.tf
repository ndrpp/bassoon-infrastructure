resource "aws_s3_bucket" "website_origin_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "allow_cloudfront_access" {
  bucket = aws_s3_bucket.website_origin_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  statement {
    sid = "AllowPublicReadAccessWithRefererRestriction"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.website_origin_bucket.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      values   = [var.referer_header]
      variable = "aws:Referer"
    }
  }

  depends_on = [aws_s3_bucket_public_access_block.bucket_allow_public_access]
}

resource "aws_s3_bucket_public_access_block" "bucket_allow_public_access" {
  bucket = aws_s3_bucket.website_origin_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "bucket_web_configuration" {
  bucket = aws_s3_bucket.website_origin_bucket.id

  index_document {
    suffix = "index.html"
  }

  //TODO
  //error_document {
  //  key = "error.html"
  //}
}

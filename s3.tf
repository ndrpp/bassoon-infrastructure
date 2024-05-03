resource "aws_s3_bucket" "website_origin_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "allow_cloudfront_access" {
  bucket = aws_s3_bucket.website_origin_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  statement {
    sid = "AllowCloudFrontGetObjectAccess"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    //condition {
    //  test     = "StringEquals"
    //  variable = "AWS:SourceArn"
    //  values   = [aws_cloudfront_distribution.website_distribution.arn]
    //}

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.website_origin_bucket.arn}/*",
    ]
  }
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

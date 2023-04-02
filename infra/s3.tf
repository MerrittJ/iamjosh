resource "aws_s3_bucket" "iamjosh_logs" {
  bucket = "iamjosh-logs"
}

resource "aws_s3_bucket_acl" "iamjosh_logs_acl" {
  bucket = aws_s3_bucket.iamjosh_logs.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "iamjosh" {
  bucket = var.domain_name
}

resource "aws_s3_bucket_policy" "iamjosh_policy_config" {
  bucket = aws_s3_bucket.iamjosh.id
  policy = data.aws_iam_policy_document.iamjosh_policy.json
}

resource "aws_s3_bucket_acl" "iamjosh_acl" {
  bucket = aws_s3_bucket.iamjosh.id
  acl    = "public-read"
}

resource "aws_s3_bucket_logging" "iamjosh_logs_config" {
  bucket        = aws_s3_bucket.iamjosh.id
  target_bucket = aws_s3_bucket.iamjosh_logs.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_website_configuration" "iamjosh_static_config" {
  bucket = aws_s3_bucket.iamjosh.id
  index_document {
    suffix = "index.html"
  }
}

data "aws_iam_policy_document" "iamjosh_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.iamjosh.arn,
      "${aws_s3_bucket.iamjosh.arn}/*",
    ]
  }
}

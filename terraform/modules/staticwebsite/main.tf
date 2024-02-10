data "aws_region" "current" {}

locals{
  default_tags = {
        "Region" = data.aws_region.current.name
    }

  bucket_name = format("%s-%s",
                    "bucket", 
                    var.bucket_name)

  s3_origin_id = var.bucket_name
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    {
        Name = local.bucket_name
    },
    local.default_tags,
    var.tags
  )
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AllowGetObjects"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.this.arn}/**"
      }
    ]
  })
}

resource "aws_s3_object" "object" {
  count        = var.upload_sample_file ? 1 : 0
  bucket       = aws_s3_bucket.this.bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "errorobject" {
  count        = var.upload_sample_file ? 1 : 0
  bucket       = aws_s3_bucket.this.bucket
  key          = "error.html"
  source       = "${path.module}/error.html"
  content_type = "text/html"
}

##################
# CloudFront
##################

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.this.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }
  
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    viewer_protocol_policy = "HTTP and HTTPS"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = merge(
    local.default_tags,
    var.tags
  )

  viewer_certificate {
    cloudfront_default_certificate = false
  }

}

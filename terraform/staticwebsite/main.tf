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

# resource "aws_s3_bucket_acl" "this" {
#   bucket = aws_s3_bucket.this.id
#   acl = "public-read"
# }

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
    "Version": "2012-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
      {
        "Sid": "AllowCloudFrontServicePrincipal",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.this.arn}/*",
        "Condition": {
          "StringEquals": {
            "AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"
          }
        }
      }
    ]
  })
}

# resource "aws_s3_object" "object" {
#   count        = var.upload_sample_file ? 1 : 0
#   bucket       = aws_s3_bucket.this.bucket
#   key          = "index.html"
#   source       = "${path.module}/index.html"
#   content_type = "text/html"
# }

# resource "aws_s3_object" "errorobject" {
#   count        = var.upload_sample_file ? 1 : 0
#   bucket       = aws_s3_bucket.this.bucket
#   key          = "error.html"
#   source       = "${path.module}/error.html"
#   content_type = "text/html"
# }

##################
# CloudFront
##################

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "controlSettingStaticWebsite"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.this.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    origin_id                = local.s3_origin_id
  }  

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = merge(
    local.default_tags,
    var.tags
  )

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}

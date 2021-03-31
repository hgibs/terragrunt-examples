resource "aws_cloudfront_origin_access_identity" "static_web" {
  comment = "This is for S3 web hosting via cloudfront."
}

resource "aws_cloudfront_distribution" "s3_static_distribution" {
  origin {
    domain_name = aws_s3_bucket.static.bucket_regional_domain_name
    origin_id   = var.s3_web_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_web.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Static website."
  default_root_object = "index.html"

  aliases = ["www.${var.domain_name}"]

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/error.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_web_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    # viewer_protocol_policy = "allow-all"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.wildcard_validation.certificate_arn #This ensures the validation is complete
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

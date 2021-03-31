resource "aws_acm_certificate" "wildcard_certificate" {
  domain_name = "*.${var.domain_name}"
  # subject_alternative_names = ["*.${var.domain_name}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "wildcard_validation" {
  certificate_arn         = aws_acm_certificate.wildcard_certificate.arn
  validation_record_fqdns = [for record in cloudflare_record.acm_records : record.hostname]
}

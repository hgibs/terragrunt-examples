resource "cloudflare_record" "www_cname" {
  zone_id = var.domain_zone_id
  name    = "www.${var.domain_name}"
  value   = aws_cloudfront_distribution.s3_static_distribution.domain_name
  type    = "CNAME"
  ttl     = 120
  proxied = false #true breaks the redirection
}

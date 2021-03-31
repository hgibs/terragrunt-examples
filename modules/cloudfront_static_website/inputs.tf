variable "domain_name" {
  type        = string
  description = "Your domain name, i.e. example.com or prod.example.com"
}

variable "domain_zone_id" {
  type        = string
  description = "Your cloudflare zone id of the `domain_name`."
}

variable "s3_web_origin_id" {
  type        = string
  description = "Some unique origin ID for cloudfront s3"
}

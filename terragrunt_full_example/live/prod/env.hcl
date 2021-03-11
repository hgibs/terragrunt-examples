# prod-specific variables
locals {
  account_prefix = "prod"
  aws_account_id = "987654321"
  aws_access_key = get_env("AWS_ACCESS_KEY_PROD")
  aws_secret_key = get_env("AWS_SECRET_KEY_PROD")
}

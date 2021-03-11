# Dev-specific variables
locals {
  account_prefix = "dev"
  aws_account_id = "123456789"
  aws_access_key = get_env("AWS_ACCESS_KEY_DEV")
  aws_secret_key = get_env("AWS_SECRET_KEY_DEV")
}

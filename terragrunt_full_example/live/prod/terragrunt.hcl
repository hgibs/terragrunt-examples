remote_state {
  #loads the [default] credentials-set for root account
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket  = "myexampleproject-terragrunt"
    region  = "us-east-1"
    key     = "${local.prefix}/${path_relative_to_include()}/terraform.tfstate"
    encrypt = true
  }
}

terraform {
  source = "${path_relative_from_include()}/../..//modules/${path_relative_to_include()}"
}

generate "common_resources" {
  path      = "common.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "account_id" {
  description = "Account number"
  type = string
}

variable "domain_name" {
  description = "TLD of domain being applied here"
  type = string
}
EOF
}

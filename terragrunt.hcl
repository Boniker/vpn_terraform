locals {
  aws_region       = "your_aws_region"
  aws_account_id   = "your_aws_account_id"
  env              = "staging"
  alias             = "alias/bbilkevych_terraform_kms"
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:${local.alias}"
    bucket         = "bbilkevych-${local.aws_account_id}-terraform-state"    
    s3_bucket_tags = {
      Terragrunt   = "true"
      Owner        = "borys.bilkevych"
    }
    
    key            = "${local.aws_region}/${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "bbilkevych-terraform-${local.env}-${local.aws_account_id}-lock-state"
    region         = local.aws_region
    
    dynamodb_table_tags = {
      Terragrunt = "true"
      Owner      = "borys.bilkevych"
    }
  }
}

inputs = {
  aws_region             = local.aws_region
  allowed_aws_account_id = local.aws_account_id

  terraform_remote_state_s3_bucket      = "bbilkevych-${local.aws_account_id}-terraform-state"
  terraform_remote_state_dynamodb_table = "terraform-lock-state"
  terraform_remote_state_file_name      = "terraform.tfstate"

  default_provider_tags = {
    Terraform    = "true"
    Student      = "borys.bilkevych"
  }
}

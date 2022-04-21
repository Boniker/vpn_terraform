variable "aws_region" {}
variable "terraform_remote_state_s3_bucket" {}
variable "terraform_remote_state_dynamodb_table" {}
variable "terraform_remote_state_file_name" {}
variable "allowed_aws_account_id" {}
variable "default_provider_tags" { type = map(any) }
variable "tags" {
  type        = map(string)
  description = "Tags applied to the KMS key."
  default     = {}
}
variable "instance_names" {
  default     = ["cat", "dog", "fox"]
  description = "List of instance names"
}
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "${var.terraform_remote_state_s3_bucket}"
    key    = "${var.aws_region}/vpc/terraform.tfstate"
    region = var.aws_region
  }
}

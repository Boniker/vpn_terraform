provider "aws" {
  region = var.aws_region
  alias  = "account_route53"

  default_tags {
    tags = {
      Student   = "borys.bilkevych"
      Terrafrom = "True"
    }
  }
}
################
# Provider AWS #
################
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Student   = "borys.bilkevych"
      Terrafrom = "True"
    }
  }
}

################################
# Provider AWS utils CloudPasse#
################################
provider "awsutils" {
  region = var.region
  default_tags {
    tags = {
      Student   = "borys.bilkevych"
      Terrafrom = "True"
    }
  }
}

##################################
#Get the latest version of Ubuntu#
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server*"]
  }
}

######################################
#Get a public IP of the local machine#
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

#################################################
#Data for ACM/check the existence of the Route53#
data "aws_route53_zone" "this" {
  count = local.use_existing_route53_zone ? 1 : 0

  name         = local.domain_name
  private_zone = false
}
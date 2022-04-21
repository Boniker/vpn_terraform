#Check the existence of the route53 #
resource "aws_route53_zone" "this" {
  count = !local.use_existing_route53_zone ? 1 : 0
  name  = local.domain_name
}

######################
#   ACM certificate  #
######################
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.0"

  domain_name = local.domain_name
  zone_id     = coalescelist(data.aws_route53_zone.this.*.zone_id, aws_route53_zone.this.*.zone_id)[0]
  subject_alternative_names = [
    "*.monitoring.${local.domain_name}",
    "*.test.${local.domain_name}",
    "*.${local.domain_name}"
  ]

  wait_for_validation = true

  tags = {
    Student   = "borys.bilkevych"
    Terrafrom = "True"
  }
}

# Create a Route53 record #
resource "aws_route53_record" "alias_route53_record" {
  zone_id = coalescelist(data.aws_route53_zone.this.*.zone_id, aws_route53_zone.this.*.zone_id)[0]
  name    = local.route53_record_name
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = false
  }
}

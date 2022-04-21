###########################
#      WAF for ALB        #
###########################
module "waf" {
  source  = "umotif-public/waf-webaclv2/aws"
  version = "3.5.0"

  name_prefix            = "waf-alb"
  alb_arn                = module.alb.lb_arn
  create_alb_association = true
  allow_default_action   = true

  visibility_config = {
    metric_name = "waf-alb-waf-main-metrics"
  }

  rules = [
    #Rules for IP Rate Limit#
    {
      name     = "IpRateBasedRule"
      priority = "1"

      action = "block"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "IpRateBasedRule-metric"
        sampled_requests_enabled   = true
      }

      rate_based_statement = {
        limit              = 300000
        #300000, because there are value for 5 minute range
        #What's why 300000/5min = 1000 per/sec, as needed
        aggregate_key_type = "IP"
      }
    }
  ]

  tags = {
    Student   = "borys.bilkevych"
    Terrafrom = "True"
  }
}
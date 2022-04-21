###########################
#Application Load Balancer#
###########################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.6.1"

  name = "alb-terraform-hw-7"

  load_balancer_type = "application"

  vpc_id          = data.terraform_remote_state.network.outputs.vpc_target
  subnets         = local.subnets_ids_public
  security_groups = [module.sg.id]

  target_groups = [
    {
      name             = "tg-terraform-hw-7"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets          = local.alb_targets
    }
  ]

  #Listenter for not Bonus Point, just 80 - http#
  # http_tcp_listeners = [
  #   {
  #     port               = 80
  #     protocol           = "HTTP"
  #     target_group_index = 0
  #   }
  # ]

  #Listener for Bonus POINT, with redirect and certificate HTTPS#
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "${module.acm.acm_certificate_arn}"
      target_group_index = 0
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        host        = local.route53_record_name
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
}
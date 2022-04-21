locals {
  #####################################
  #List of private/public subnet's ids#
  #####################################
  subnets_ids_private = data.terraform_remote_state.network.outputs.subnets_private
  subnets_ids_public  = data.terraform_remote_state.network.outputs.subnets_public

  #############################################
  #Locals for instance's ids and target groups#
  #############################################
  instance_target_ids_list = [for instance in aws_instance.ec2_nginx : instance.id]
  alb_targets = [for id in local.instance_target_ids_list :
    {
      target_id = id
      port      = 80
    }
  ]

  ############################
  #Locals for ACM certificate#
  ############################
  use_existing_route53_zone = true
  domain                    = "bbilkevich.student.java-academy.xyz"
  domain_name               = trimsuffix(local.domain, ".")
  route53_record_name       = "test.${local.domain_name}"
}
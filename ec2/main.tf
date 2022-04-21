############################
# Creating the Key for EC2s#
############################
resource "tls_private_key" "ec2_keypair" {
  algorithm = "RSA"
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "1.0.1"

  key_name   = "bbilkevych_ssh_key"
  public_key = tls_private_key.ec2_keypair.public_key_openssh
}

##########################################
#  Creating EC2(docker+nginx) instances  #
##########################################
resource "aws_instance" "ec2_nginx" {
  count = length(local.subnets_ids_private)

  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = local.subnets_ids_private[count.index]
  key_name               = module.key_pair.key_pair_key_name
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.sg_vpn]
  security_groups = [resource.aws_security_group.alb_myip_sg.id]

  #Connect to the instance#
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ec2_keypair.private_key_pem
    host        = self.private_ip
  }

  #Provisioner files and remote-exec#
  provisioner "file" {
    source      = "user_data/docker.sh"
    destination = "/tmp/docker.sh"
  }

  provisioner "file" {
    source      = "user_data/Dockerfile"
    destination = "/home/ubuntu/Dockerfile"
  }

  provisioner "file" {
    source      = "user_data/index.html"
    destination = "index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /tmp/docker.sh",
      "sudo sh /tmp/docker.sh",
      "sudo docker build -t webserver .",
      "sudo docker run -it --rm -d -p 80:80 --name web webserver"
    ]
  }

  #########################################################################
  # Provisioner file and remote-exec for nginx inside the EC2 (not secure)#
  #########################################################################
  # provisioner "file" {
  #   source      = "user_data/configuration.sh"
  #   destination = "/tmp/configuration.sh"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo chmod 777 /tmp/configuration.sh",
  #     "sudo sh /tmp/configuration.sh",
  #     "sudo rm -rf /var/www/html/index.html",
  #     "sudo adduser ubuntu www-data",
  #     "sudo chown ubuntu:www-data -R /var/www"
  #   ]
  # }

  # provisioner "file" {
  #   source      = "user_data/index.html"
  #   destination = "/var/www/html/index.html"
  # }
  #########################################################################

  tags = {
    Name      = "bbilkevych-ec2-hw-7-${element(var.instance_names, count.index)}"
    Student   = "borys.bilkevych"
    Terrafrom = "True"
  }
}

############################
#  Security Group for EC2  #
############################
resource "aws_security_group" "alb_myip_sg" {
  name        = "ec2_security_group"
  description = "Allow inbound traffic for EC2"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_target

  ingress {
    description = "HTTP for EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [module.sg.id]
  }

  ingress {
    description = "HTTPS for EC2"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [module.sg.id]
  }

  ingress {
    description = "SSH for EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [data.terraform_remote_state.network.outputs.sg_vpn]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${data.terraform_remote_state.network.outputs.vpc_target_cidr_block_client}"]
  }
}

############################
#  Security Group for ALB  #
############################
module "sg" {
  source  = "cloudposse/security-group/aws"
  version = "0.4.3"

  name             = "alb_security_group"
  vpc_id           = data.terraform_remote_state.network.outputs.vpc_target
  allow_all_egress = true

  rules = [
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
      description = "Allow HTTP"
    },
    {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
      description = "Allow HTTPS"
    }
  ]

  tags = {
    Student   = "borys.bilkevych"
    Terrafrom = "True"
  }
}
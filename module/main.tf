terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.11"
    }
  }
}

locals {
  app_subnet_cidr_blocks = [for s in module.network.aws_subnet.app : s.cidr_block]
}

module "network" {
  source      = "git::git@github.com:BCDevOps/terraform-octk-aws-sea-network-info?ref=master"
  environment = var.environment
}

resource "aws_security_group" "lb" {
  name        = "${var.name}-lb-security-group"
  description = "controls access to the ALB"
  vpc_id      = module.network.aws_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [module.network.aws_vpc.cidr_block]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 0
    cidr_blocks = local.app_subnet_cidr_blocks
  }

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 0
    cidr_blocks = local.app_subnet_cidr_blocks
  }
}

resource "aws_alb" "this" {
  name               = var.name
  load_balancer_type = "application"
  internal           = true
  subnets            = module.network.aws_subnet_ids.web.ids
  security_groups    = [aws_security_group.lb.id]
}

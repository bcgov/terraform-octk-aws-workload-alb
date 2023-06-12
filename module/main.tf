locals {
  app_subnet_cidr_blocks = [for s in module.network.aws_subnet.app : s.cidr_block]
}

module "network" {
  source      = "git::https://github.com/BCDevOps/terraform-octk-aws-sea-network-info.git?ref=master"
  environment = var.environment
}

data "aws_security_group" "lb" {
  name = "Web_sg"
}

resource "aws_alb" "this" {
  name               = var.name
  load_balancer_type = "application"
  internal           = true
  subnets            = module.network.aws_subnet_ids.web.ids
  security_groups    = [data.aws_security_group.lb.id]

  # Ignore access logs, the ASEA stack will handle them
  lifecycle {
    ignore_changes = [access_logs["enabled"]]
  }
}

resource "aws_alb_listener" "secure" {
  load_balancer_arn = aws_alb.this.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.default.arn


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
    }
  }
}

data "aws_acm_certificate" "default" {
  domain   = var.alb_cert_domain
  statuses = ["ISSUED", "EXPIRED"]
}

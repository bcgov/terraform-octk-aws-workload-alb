terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.11"
    }
  }
}

locals {
  environment            = title(var.environment)
  vpc_name               = "${local.environment}_vpc"
  availability_zones     = list("a", "b")
  web_subnet_names       = [for az in local.availability_zones : "Web_${local.environment}_az${az}_net"]
  app_subnet_names       = [for az in local.availability_zones : "App_${local.environment}_az${az}_net"]
  app_subnet_cidr_blocks = [for s in data.aws_subnet.app : s.cidr_block]
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnet_ids" "web" {
  vpc_id = data.aws_vpc.main.id
  filter {
    name   = "tag:Name"
    values = local.web_subnet_names
  }
}

data "aws_subnet_ids" "app" {
  vpc_id = data.aws_vpc.main.id
  filter {
    name   = "tag:Name"
    values = local.app_subnet_names
  }
}

data "aws_subnet" "web" {
  for_each = data.aws_subnet_ids.web.ids
  id       = each.value
}

data "aws_subnet" "app" {
  for_each = data.aws_subnet_ids.app.ids
  id       = each.value
}

resource "aws_security_group" "lb" {
  name        = "internal-workload-lb-security-group"
  description = "controls access to the ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [data.aws_vpc.main.cidr_block]
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
  name               = "internal-workload-lb"
  load_balancer_type = "application"
  internal           = true
  subnets            = data.aws_subnet_ids.web.ids
  security_groups    = [aws_security_group.lb.id]
}

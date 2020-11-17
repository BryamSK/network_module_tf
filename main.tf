
# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.12.26"
}

# # ---------------------------------------------------------------------------------------------------------------------
# # GET THE LIST OF AVAILABILITY ZONES IN THE CURRENT REGION
# # Every AWS accout has slightly different availability zones in each region. For example, one account might have
# # us-east-1a, us-east-1b, and us-east-1c, while another will have us-east-1a, us-east-1b, and us-east-1d. This resource
# # queries AWS to fetch the list for the current account and region.
# # ---------------------------------------------------------------------------------------------------------------------

data "aws_availability_zones" "all" {}


# ---------------------------------------------------------------------------------------------------------------------
# CALL MODULE terraform-cidr-subnets FOR CREATE IPS
# ---------------------------------------------------------------------------------------------------------------------

module "subnet_addrs" {
  source = "github.com/BryamSK/subnet_module_tf?ref=v0.0.2"

  base_cidr_block = var.base_cidr_block
  networks = var.networks
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "aws-vpc" { 
  cidr_block = module.subnet_addrs.base_cidr_block
  enable_dns_hostnames = true
    tags = {
    name = "${var.project_name}-vpc"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE internet_gateway
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_internet_gateway" "aws-gw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name = "${var.project_name}-aws-gw"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SUBNET
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "subnet" {
  for_each =  module.subnet_addrs.network_cidr_blocks
  vpc_id     = aws_vpc.aws-vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
  tags       = {
   Name = "${var.project_name}-sub"
  } 
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE security_group
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-security-group-alb"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.aws-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  } 
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-security-group-ecs_tasks"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.aws-vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}